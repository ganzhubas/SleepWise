import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import '../models/sleep_phase.dart';
import '../models/sleep_sample.dart';
import '../models/sleep_session.dart';

// ---------------------------------------------------------------------------
// Configuration
// ---------------------------------------------------------------------------

class AudioAnalysisConfig {
  /// Duration of each audio capture window.
  final Duration sampleDuration;

  /// Interval between consecutive samples.
  final Duration sampleInterval;

  /// Interval for aggregating samples into a single phase entry.
  final Duration phaseResolution;

  /// Minimum time a phase must persist before it can change.
  final Duration minPhaseDuration;

  /// RMS threshold below which audio is considered silence.
  final double silenceThreshold;

  /// RMS threshold for low activity.
  final double lowActivityThreshold;

  /// RMS threshold for medium activity.
  final double mediumActivityThreshold;

  /// Snoring detection: minimum ratio of low-band energy to total energy.
  final double snoringLowBandRatio;

  /// Snoring detection: minimum RMS to even consider snoring.
  final double snoringMinRms;

  /// Snoring detection: maximum ZCR (snoring is low-frequency).
  final double snoringMaxZcr;

  const AudioAnalysisConfig({
    this.sampleDuration = const Duration(seconds: 5),
    this.sampleInterval = const Duration(seconds: 30),
    this.phaseResolution = const Duration(minutes: 5),
    this.minPhaseDuration = const Duration(minutes: 10),
    this.silenceThreshold = 0.02,
    this.lowActivityThreshold = 0.08,
    this.mediumActivityThreshold = 0.25,
    this.snoringLowBandRatio = 0.65,
    this.snoringMinRms = 0.03,
    this.snoringMaxZcr = 0.15,
  });
}

// ---------------------------------------------------------------------------
// Audio source abstraction (allows mocking in tests)
// ---------------------------------------------------------------------------

/// Provides raw PCM audio samples. Implement with real microphone or mock.
abstract class AudioSource {
  /// Start the audio stream / microphone.
  Future<void> start();

  /// Stop the audio stream.
  Future<void> stop();

  /// Capture a single buffer of PCM 16-bit samples.
  /// Returns normalized float values in range [-1.0, 1.0].
  Future<Float64List> capture(Duration duration);

  /// Sample rate in Hz.
  int get sampleRate;
}

// ---------------------------------------------------------------------------
// Feature extraction (pure functions — easy to test)
// ---------------------------------------------------------------------------

class AudioFeatures {
  /// Root Mean Square — average loudness.
  static double computeRms(Float64List samples) {
    if (samples.isEmpty) return 0;
    var sum = 0.0;
    for (final s in samples) {
      sum += s * s;
    }
    return sqrt(sum / samples.length);
  }

  /// Peak absolute amplitude.
  static double computePeak(Float64List samples) {
    if (samples.isEmpty) return 0;
    var peak = 0.0;
    for (final s in samples) {
      final abs = s.abs();
      if (abs > peak) peak = abs;
    }
    return peak;
  }

  /// Zero-crossing rate, normalized to [0, 1].
  static double computeZcr(Float64List samples) {
    if (samples.length < 2) return 0;
    var crossings = 0;
    for (var i = 1; i < samples.length; i++) {
      if ((samples[i] >= 0) != (samples[i - 1] >= 0)) {
        crossings++;
      }
    }
    // Normalize: max possible crossings = samples.length - 1
    return crossings / (samples.length - 1);
  }

  /// Split spectrum into 4 frequency bands using a simple DFT approach.
  /// Bands: low (0–250 Hz), mid (250–1 kHz), high (1–4 kHz), veryHigh (4 kHz+).
  static FrequencyBands computeBands(Float64List samples, int sampleRate) {
    if (samples.isEmpty) {
      return const FrequencyBands(low: 0, mid: 0, high: 0, veryHigh: 0);
    }

    final n = samples.length;
    // Use power-of-2 FFT size for efficiency
    final fftSize = _nextPow2(min(n, 2048));
    final halfSize = fftSize ~/ 2;

    // Compute magnitude spectrum via DFT (simplified — real part only for
    // energy estimation; sufficient for our heuristic use-case).
    final magnitudes = Float64List(halfSize);
    final freqStep = sampleRate / fftSize;

    for (var k = 0; k < halfSize; k++) {
      var real = 0.0;
      var imag = 0.0;
      for (var n2 = 0; n2 < fftSize && n2 < n; n2++) {
        final angle = -2 * pi * k * n2 / fftSize;
        real += samples[n2] * cos(angle);
        imag += samples[n2] * sin(angle);
      }
      magnitudes[k] = sqrt(real * real + imag * imag) / fftSize;
    }

    // Accumulate energy per band
    var low = 0.0, mid = 0.0, high = 0.0, veryHigh = 0.0;
    for (var k = 0; k < halfSize; k++) {
      final freq = k * freqStep;
      final energy = magnitudes[k] * magnitudes[k];
      if (freq < 250) {
        low += energy;
      } else if (freq < 1000) {
        mid += energy;
      } else if (freq < 4000) {
        high += energy;
      } else {
        veryHigh += energy;
      }
    }

    // Normalize so total = 1 (ratio-based classification is easier)
    final total = low + mid + high + veryHigh;
    if (total == 0) {
      return const FrequencyBands(low: 0, mid: 0, high: 0, veryHigh: 0);
    }
    return FrequencyBands(
      low: low / total,
      mid: mid / total,
      high: high / total,
      veryHigh: veryHigh / total,
    );
  }

  static int _nextPow2(int n) {
    var p = 1;
    while (p < n) {
      p <<= 1;
    }
    return p;
  }
}

// ---------------------------------------------------------------------------
// Classifier (pure function)
// ---------------------------------------------------------------------------

class ActivityClassifier {
  final AudioAnalysisConfig config;

  const ActivityClassifier([this.config = const AudioAnalysisConfig()]);

  ActivityLevel classify({
    required double rms,
    required double peak,
    required double zcr,
    required FrequencyBands bands,
  }) {
    // 1. Check for snoring first (specific pattern overrides general level)
    if (_isSnoring(rms: rms, zcr: zcr, bands: bands)) {
      return ActivityLevel.snoring;
    }

    // 2. General activity level based on RMS thresholds
    if (rms < config.silenceThreshold) {
      return ActivityLevel.silence;
    }
    if (rms < config.lowActivityThreshold) {
      return ActivityLevel.lowActivity;
    }
    if (rms < config.mediumActivityThreshold) {
      return ActivityLevel.mediumActivity;
    }
    return ActivityLevel.highActivity;
  }

  bool _isSnoring({
    required double rms,
    required double zcr,
    required FrequencyBands bands,
  }) {
    // Snoring requires: audible sound, low frequency dominance, low ZCR
    return rms >= config.snoringMinRms &&
        zcr <= config.snoringMaxZcr &&
        bands.low >= config.snoringLowBandRatio;
  }
}

// ---------------------------------------------------------------------------
// Hypnogram builder (pure function — maps ActivityLevel → SleepPhaseType)
// ---------------------------------------------------------------------------

class HypnogramBuilder {
  final AudioAnalysisConfig config;

  const HypnogramBuilder([this.config = const AudioAnalysisConfig()]);

  /// Map a single activity level to a sleep phase type.
  static SleepPhaseType activityToPhase(ActivityLevel activity) {
    return switch (activity) {
      ActivityLevel.silence => SleepPhaseType.deep,
      ActivityLevel.lowActivity => SleepPhaseType.light,
      ActivityLevel.mediumActivity => SleepPhaseType.rem,
      ActivityLevel.highActivity => SleepPhaseType.awake,
      ActivityLevel.snoring => SleepPhaseType.deep,
    };
  }

  /// Build a smoothed hypnogram from a list of samples.
  ///
  /// 1. Group samples into [phaseResolution] windows (default 5 min).
  /// 2. Pick the dominant activity in each window → map to phase.
  /// 3. Apply minimum-phase-duration smoothing.
  List<SleepPhase> build(List<SleepSample> samples) {
    if (samples.isEmpty) return [];

    // Sort by time
    final sorted = List<SleepSample>.from(samples)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final start = sorted.first.timestamp;
    final end = sorted.last.timestamp;

    // Step 1: Group into windows and find dominant activity
    final windowPhases = <_WindowEntry>[];
    var windowStart = start;

    while (windowStart.isBefore(end) ||
        windowStart.isAtSameMomentAs(end)) {
      final windowEnd = windowStart.add(config.phaseResolution);

      final windowSamples = sorted.where((s) =>
          !s.timestamp.isBefore(windowStart) &&
          s.timestamp.isBefore(windowEnd));

      if (windowSamples.isNotEmpty) {
        final dominant = _dominantActivity(windowSamples.toList());
        windowPhases.add(_WindowEntry(
          start: windowStart,
          end: windowEnd,
          phase: activityToPhase(dominant),
        ));
      }

      windowStart = windowEnd;
    }

    if (windowPhases.isEmpty) return [];

    // Step 2: Apply minimum-duration smoothing
    final smoothed = _smooth(windowPhases);

    // Step 3: Merge consecutive identical phases
    return _merge(smoothed);
  }

  /// Returns the most common activity level in a window.
  ActivityLevel _dominantActivity(List<SleepSample> samples) {
    final counts = <ActivityLevel, int>{};
    for (final s in samples) {
      counts[s.classification] = (counts[s.classification] ?? 0) + 1;
    }
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  /// Smooth: if a phase appears for less than [minPhaseDuration], replace it
  /// with the surrounding phase (prefer the previous phase).
  List<_WindowEntry> _smooth(List<_WindowEntry> windows) {
    if (windows.length <= 1) return windows;

    final minWindows =
        config.minPhaseDuration.inMilliseconds ~/
        config.phaseResolution.inMilliseconds;

    final result = List<_WindowEntry>.from(windows);

    // Multiple passes until stable
    for (var pass = 0; pass < 3; pass++) {
      var changed = false;
      var i = 0;
      while (i < result.length) {
        // Count consecutive windows with same phase
        var runLength = 1;
        while (i + runLength < result.length &&
            result[i + runLength].phase == result[i].phase) {
          runLength++;
        }

        if (runLength < minWindows) {
          // Replace short run with neighbor phase
          final replacement = i > 0
              ? result[i - 1].phase
              : (i + runLength < result.length
                  ? result[i + runLength].phase
                  : result[i].phase);

          for (var j = i; j < i + runLength; j++) {
            if (result[j].phase != replacement) {
              result[j] = _WindowEntry(
                start: result[j].start,
                end: result[j].end,
                phase: replacement,
              );
              changed = true;
            }
          }
        }
        i += runLength;
      }
      if (!changed) break;
    }

    return result;
  }

  /// Merge consecutive windows with the same phase into single SleepPhase.
  List<SleepPhase> _merge(List<_WindowEntry> windows) {
    if (windows.isEmpty) return [];

    final phases = <SleepPhase>[];
    var currentStart = windows.first.start;
    var currentPhase = windows.first.phase;

    for (var i = 1; i < windows.length; i++) {
      if (windows[i].phase != currentPhase) {
        phases.add(SleepPhase(
          type: currentPhase,
          startTime: currentStart,
          endTime: windows[i].start,
        ));
        currentStart = windows[i].start;
        currentPhase = windows[i].phase;
      }
    }
    // Last phase
    phases.add(SleepPhase(
      type: currentPhase,
      startTime: currentStart,
      endTime: windows.last.end,
    ));

    return phases;
  }
}

class _WindowEntry {
  final DateTime start;
  final DateTime end;
  final SleepPhaseType phase;

  const _WindowEntry({
    required this.start,
    required this.end,
    required this.phase,
  });
}

// ---------------------------------------------------------------------------
// Wake window detector
// ---------------------------------------------------------------------------

class WakeDetector {
  /// Check whether the user is in a light sleep phase suitable for waking.
  ///
  /// Returns `true` if:
  /// - Current activity is [lowActivity] (light sleep), OR
  /// - Recent transition from [silence] → [lowActivity] (surfacing), OR
  /// - The wake window has expired (force wake).
  static bool shouldWake({
    required List<SleepSample> recentSamples,
    required DateTime windowStart,
    required DateTime windowEnd,
    required DateTime now,
  }) {
    // Force wake if window expired
    if (!now.isBefore(windowEnd)) return true;

    // Not yet in the wake window
    if (now.isBefore(windowStart)) return false;

    // Need at least 2 samples to detect transition
    if (recentSamples.length < 2) return false;

    // Sort descending (most recent first)
    final sorted = List<SleepSample>.from(recentSamples)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    final latest = sorted.first.classification;
    final previous = sorted[1].classification;

    // Light sleep right now
    if (latest == ActivityLevel.lowActivity) return true;

    // Transitioning from deep → light
    if (previous == ActivityLevel.silence &&
        latest == ActivityLevel.lowActivity) {
      return true;
    }

    // Medium activity also acceptable (REM ending)
    if (latest == ActivityLevel.mediumActivity &&
        previous == ActivityLevel.silence) {
      return true;
    }

    return false;
  }
}

// ---------------------------------------------------------------------------
// Score calculator
// ---------------------------------------------------------------------------

class SleepScoreCalculator {
  /// Calculate a 0–100 sleep quality score from phases and session duration.
  static int calculate({
    required Duration totalDuration,
    required List<SleepPhase> phases,
    required int snoreSampleCount,
    required int totalSampleCount,
  }) {
    if (phases.isEmpty || totalDuration.inMinutes == 0) return 0;

    var score = 0.0;
    final totalMin = totalDuration.inMinutes;

    // 1. Duration score (max 30 pts): 7–9 hours is ideal
    final hours = totalMin / 60;
    if (hours >= 7 && hours <= 9) {
      score += 30;
    } else if (hours >= 6 && hours < 7) {
      score += 20;
    } else if (hours > 9 && hours <= 10) {
      score += 22;
    } else if (hours >= 5) {
      score += 10;
    }

    // 2. Deep sleep score (max 25 pts): ideal 15-25%
    final deepMin = phases
        .where((p) => p.type == SleepPhaseType.deep)
        .fold<int>(0, (s, p) => s + p.duration.inMinutes);
    final deepPct = deepMin / totalMin * 100;
    if (deepPct >= 15 && deepPct <= 25) {
      score += 25;
    } else if (deepPct >= 10) {
      score += 15;
    } else if (deepPct >= 5) {
      score += 8;
    }

    // 3. REM score (max 20 pts): ideal 20-30%
    final remMin = phases
        .where((p) => p.type == SleepPhaseType.rem)
        .fold<int>(0, (s, p) => s + p.duration.inMinutes);
    final remPct = remMin / totalMin * 100;
    if (remPct >= 20 && remPct <= 30) {
      score += 20;
    } else if (remPct >= 10) {
      score += 12;
    } else if (remPct >= 5) {
      score += 6;
    }

    // 4. Awake penalty (max -15 pts)
    final awakeMin = phases
        .where((p) => p.type == SleepPhaseType.awake)
        .fold<int>(0, (s, p) => s + p.duration.inMinutes);
    final awakePct = awakeMin / totalMin * 100;
    if (awakePct > 15) {
      score -= 15;
    } else if (awakePct > 10) {
      score -= 10;
    } else if (awakePct > 5) {
      score -= 5;
    }

    // 5. Snoring penalty (max -10 pts)
    if (totalSampleCount > 0) {
      final snorePct = snoreSampleCount / totalSampleCount * 100;
      if (snorePct > 30) {
        score -= 10;
      } else if (snorePct > 15) {
        score -= 5;
      }
    }

    // 6. Base points for actually sleeping
    score += 25;

    return score.round().clamp(0, 100);
  }
}

// ---------------------------------------------------------------------------
// Main service — orchestrates recording, analysis, and session building
// ---------------------------------------------------------------------------

class AudioAnalysisService {
  final AudioSource _source;
  final AudioAnalysisConfig config;
  final ActivityClassifier _classifier;
  final HypnogramBuilder _hypnogramBuilder;

  Timer? _recordingTimer;
  final List<SleepSample> _samples = [];
  DateTime? _sessionStart;
  bool _isRecording = false;

  /// Stream controller that emits each new sample as it's captured.
  final _sampleController = StreamController<SleepSample>.broadcast();

  /// Stream of live samples during recording.
  Stream<SleepSample> get sampleStream => _sampleController.stream;

  bool get isRecording => _isRecording;
  List<SleepSample> get samples => List.unmodifiable(_samples);

  AudioAnalysisService({
    required AudioSource source,
    this.config = const AudioAnalysisConfig(),
  })  : _source = source,
        _classifier = ActivityClassifier(config),
        _hypnogramBuilder = HypnogramBuilder(config);

  /// Start capturing audio samples at the configured interval.
  Future<void> startRecording() async {
    if (_isRecording) return;

    await _source.start();
    _isRecording = true;
    _sessionStart = DateTime.now();
    _samples.clear();

    // Capture first sample immediately
    await _captureSample();

    // Then capture at interval
    _recordingTimer = Timer.periodic(config.sampleInterval, (_) {
      _captureSample();
    });
  }

  /// Stop recording and return the completed session.
  Future<SleepSession> stopRecording() async {
    _recordingTimer?.cancel();
    _recordingTimer = null;
    _isRecording = false;

    await _source.stop();

    return buildSession();
  }

  /// Build a SleepSession from the collected samples.
  SleepSession buildSession() {
    final start = _sessionStart ?? DateTime.now();
    final end = _samples.isNotEmpty
        ? _samples.last.timestamp
        : DateTime.now();

    final phases = _hypnogramBuilder.build(_samples);

    final snoreCount =
        _samples.where((s) => s.classification == ActivityLevel.snoring).length;
    final snorePercentage = _samples.isNotEmpty
        ? (snoreCount / _samples.length * 100).round()
        : 0;

    final score = SleepScoreCalculator.calculate(
      totalDuration: end.difference(start),
      phases: phases,
      snoreSampleCount: snoreCount,
      totalSampleCount: _samples.length,
    );

    return SleepSession(
      bedtime: start,
      wakeTime: end,
      phases: phases,
      samples: List.unmodifiable(_samples),
      score: score,
      snorePercentage: snorePercentage,
    );
  }

  /// Capture a single sample: record audio, extract features, classify.
  Future<void> _captureSample() async {
    try {
      final buffer = await _source.capture(config.sampleDuration);
      final sample = analyzeSample(
        buffer: buffer,
        sampleRate: _source.sampleRate,
        timestamp: DateTime.now(),
      );
      _samples.add(sample);
      _sampleController.add(sample);
    } catch (_) {
      // Skip failed captures — microphone may be temporarily unavailable
    }
  }

  /// Analyze a raw audio buffer into a classified SleepSample.
  /// Public for testing.
  SleepSample analyzeSample({
    required Float64List buffer,
    required int sampleRate,
    DateTime? timestamp,
  }) {
    final rms = AudioFeatures.computeRms(buffer);
    final peak = AudioFeatures.computePeak(buffer);
    final zcr = AudioFeatures.computeZcr(buffer);
    final bands = AudioFeatures.computeBands(buffer, sampleRate);

    final classification = _classifier.classify(
      rms: rms,
      peak: peak,
      zcr: zcr,
      bands: bands,
    );

    return SleepSample(
      timestamp: timestamp ?? DateTime.now(),
      rms: rms,
      peak: peak,
      zcr: zcr,
      bands: bands,
      classification: classification,
    );
  }

  /// Check if it's a good moment to wake the user.
  bool shouldWakeNow({
    required DateTime windowStart,
    required DateTime windowEnd,
  }) {
    // Use the last 2 samples for transition detection
    final recent = _samples.length >= 2
        ? _samples.sublist(_samples.length - 2)
        : _samples;

    return WakeDetector.shouldWake(
      recentSamples: recent,
      windowStart: windowStart,
      windowEnd: windowEnd,
      now: DateTime.now(),
    );
  }

  void dispose() {
    _recordingTimer?.cancel();
    _sampleController.close();
  }
}
