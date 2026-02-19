import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/models/sleep_phase.dart';
import 'package:sleepwise/models/sleep_sample.dart';
import 'package:sleepwise/services/audio_analysis_service.dart';

// ---------------------------------------------------------------------------
// Mock audio source for testing
// ---------------------------------------------------------------------------

class MockAudioSource implements AudioSource {
  final int _sampleRate;
  Float64List Function(Duration)? onCapture;
  bool started = false;

  MockAudioSource({int sampleRate = 16000}) : _sampleRate = sampleRate;

  @override
  int get sampleRate => _sampleRate;

  @override
  Future<void> start() async => started = true;

  @override
  Future<void> stop() async => started = false;

  @override
  Future<Float64List> capture(Duration duration) async {
    if (onCapture != null) return onCapture!(duration);
    // Default: silence
    final numSamples = (_sampleRate * duration.inMilliseconds / 1000).round();
    return Float64List(numSamples);
  }
}

// ---------------------------------------------------------------------------
// Helpers to generate test audio signals
// ---------------------------------------------------------------------------

/// Generate silence (all zeros).
Float64List generateSilence(int length) => Float64List(length);

/// Generate a sine wave at a given frequency and amplitude.
Float64List generateSineWave({
  required int sampleRate,
  required int length,
  required double frequency,
  double amplitude = 0.5,
}) {
  final data = Float64List(length);
  for (var i = 0; i < length; i++) {
    data[i] = amplitude * sin(2 * pi * frequency * i / sampleRate);
  }
  return data;
}

/// Generate random noise at a given amplitude.
Float64List generateNoise({
  required int length,
  double amplitude = 0.5,
}) {
  final rng = Random(42);
  final data = Float64List(length);
  for (var i = 0; i < length; i++) {
    data[i] = (rng.nextDouble() * 2 - 1) * amplitude;
  }
  return data;
}

/// Generate a low-frequency periodic signal simulating snoring.
Float64List generateSnoring({
  required int sampleRate,
  required int length,
  double amplitude = 0.15,
}) {
  final data = Float64List(length);
  // Snoring: strong low-freq (100 Hz) + weak harmonic (200 Hz)
  for (var i = 0; i < length; i++) {
    data[i] = amplitude * 0.8 * sin(2 * pi * 100 * i / sampleRate) +
        amplitude * 0.2 * sin(2 * pi * 200 * i / sampleRate);
  }
  return data;
}

/// Create a SleepSample with the given classification and timestamp offset.
SleepSample makeSample(
  ActivityLevel level,
  DateTime base,
  int minutesOffset,
) {
  return SleepSample(
    timestamp: base.add(Duration(minutes: minutesOffset)),
    rms: 0.01,
    peak: 0.02,
    zcr: 0.05,
    bands: const FrequencyBands(low: 0.25, mid: 0.25, high: 0.25, veryHigh: 0.25),
    classification: level,
  );
}

// ===========================================================================
// Tests
// ===========================================================================

void main() {
  const sampleRate = 16000;
  const sampleLength = 16000; // 1 second at 16 kHz

  // -------------------------------------------------------------------------
  group('AudioFeatures', () {
    test('RMS of silence is 0', () {
      final silence = generateSilence(sampleLength);
      expect(AudioFeatures.computeRms(silence), 0.0);
    });

    test('RMS of sine wave ≈ amplitude / √2', () {
      final sine = generateSineWave(
        sampleRate: sampleRate,
        length: sampleLength,
        frequency: 440,
        amplitude: 0.5,
      );
      final rms = AudioFeatures.computeRms(sine);
      // Sine RMS = amplitude / sqrt(2) ≈ 0.3536
      expect(rms, closeTo(0.3536, 0.01));
    });

    test('Peak of sine wave ≈ amplitude', () {
      final sine = generateSineWave(
        sampleRate: sampleRate,
        length: sampleLength,
        frequency: 440,
        amplitude: 0.7,
      );
      final peak = AudioFeatures.computePeak(sine);
      expect(peak, closeTo(0.7, 0.01));
    });

    test('ZCR of high-frequency signal > ZCR of low-frequency signal', () {
      final lowFreq = generateSineWave(
        sampleRate: sampleRate,
        length: sampleLength,
        frequency: 100,
      );
      final highFreq = generateSineWave(
        sampleRate: sampleRate,
        length: sampleLength,
        frequency: 4000,
      );
      final zcrLow = AudioFeatures.computeZcr(lowFreq);
      final zcrHigh = AudioFeatures.computeZcr(highFreq);
      expect(zcrHigh, greaterThan(zcrLow));
    });

    test('ZCR of silence is 0', () {
      final silence = generateSilence(sampleLength);
      expect(AudioFeatures.computeZcr(silence), 0.0);
    });

    test('Frequency bands sum to ≈ 1.0 for non-silent signal', () {
      final sine = generateSineWave(
        sampleRate: sampleRate,
        length: sampleLength,
        frequency: 440,
      );
      final bands = AudioFeatures.computeBands(sine, sampleRate);
      final total = bands.low + bands.mid + bands.high + bands.veryHigh;
      expect(total, closeTo(1.0, 0.001));
    });

    test('Low-frequency signal has dominant low band', () {
      final lowSine = generateSineWave(
        sampleRate: sampleRate,
        length: sampleLength,
        frequency: 100,
        amplitude: 0.5,
      );
      final bands = AudioFeatures.computeBands(lowSine, sampleRate);
      expect(bands.low, greaterThan(bands.mid));
      expect(bands.low, greaterThan(bands.high));
      expect(bands.low, greaterThan(bands.veryHigh));
    });

    test('Empty samples return zeros', () {
      final empty = Float64List(0);
      expect(AudioFeatures.computeRms(empty), 0.0);
      expect(AudioFeatures.computePeak(empty), 0.0);
      expect(AudioFeatures.computeZcr(empty), 0.0);
      final bands = AudioFeatures.computeBands(empty, sampleRate);
      expect(bands.low, 0.0);
    });
  });

  // -------------------------------------------------------------------------
  group('ActivityClassifier', () {
    const config = AudioAnalysisConfig();
    const classifier = ActivityClassifier(config);

    const neutralBands =
        FrequencyBands(low: 0.25, mid: 0.25, high: 0.25, veryHigh: 0.25);

    test('Very low RMS → SILENCE', () {
      final result = classifier.classify(
        rms: 0.01,
        peak: 0.02,
        zcr: 0.05,
        bands: neutralBands,
      );
      expect(result, ActivityLevel.silence);
    });

    test('Low RMS → LOW_ACTIVITY', () {
      final result = classifier.classify(
        rms: 0.05,
        peak: 0.1,
        zcr: 0.1,
        bands: neutralBands,
      );
      expect(result, ActivityLevel.lowActivity);
    });

    test('Medium RMS → MEDIUM_ACTIVITY', () {
      final result = classifier.classify(
        rms: 0.15,
        peak: 0.3,
        zcr: 0.2,
        bands: neutralBands,
      );
      expect(result, ActivityLevel.mediumActivity);
    });

    test('High RMS → HIGH_ACTIVITY', () {
      final result = classifier.classify(
        rms: 0.4,
        peak: 0.7,
        zcr: 0.3,
        bands: neutralBands,
      );
      expect(result, ActivityLevel.highActivity);
    });

    test('Low-frequency dominant + moderate RMS + low ZCR → SNORING', () {
      const snoringBands =
          FrequencyBands(low: 0.70, mid: 0.15, high: 0.10, veryHigh: 0.05);
      final result = classifier.classify(
        rms: 0.06,
        peak: 0.12,
        zcr: 0.08,
        bands: snoringBands,
      );
      expect(result, ActivityLevel.snoring);
    });

    test('Low-frequency dominant but too quiet → SILENCE (not snoring)', () {
      const snoringBands =
          FrequencyBands(low: 0.70, mid: 0.15, high: 0.10, veryHigh: 0.05);
      final result = classifier.classify(
        rms: 0.01,
        peak: 0.02,
        zcr: 0.08,
        bands: snoringBands,
      );
      expect(result, ActivityLevel.silence);
    });

    test('Moderate RMS but high ZCR → not snoring (MEDIUM_ACTIVITY)', () {
      const snoringBands =
          FrequencyBands(low: 0.70, mid: 0.15, high: 0.10, veryHigh: 0.05);
      final result = classifier.classify(
        rms: 0.15,
        peak: 0.3,
        zcr: 0.4, // high ZCR → not snoring pattern
        bands: snoringBands,
      );
      expect(result, ActivityLevel.mediumActivity);
    });

    test('Custom thresholds are respected', () {
      const custom = AudioAnalysisConfig(
        silenceThreshold: 0.05,
        lowActivityThreshold: 0.15,
      );
      const customClassifier = ActivityClassifier(custom);

      // 0.03 is below custom silence threshold
      expect(
        customClassifier.classify(
          rms: 0.03,
          peak: 0.05,
          zcr: 0.1,
          bands: neutralBands,
        ),
        ActivityLevel.silence,
      );

      // 0.10 is between custom silence and low thresholds
      expect(
        customClassifier.classify(
          rms: 0.10,
          peak: 0.2,
          zcr: 0.1,
          bands: neutralBands,
        ),
        ActivityLevel.lowActivity,
      );
    });
  });

  // -------------------------------------------------------------------------
  group('HypnogramBuilder', () {
    const config = AudioAnalysisConfig(
      phaseResolution: Duration(minutes: 5),
      minPhaseDuration: Duration(minutes: 10),
    );
    const builder = HypnogramBuilder(config);

    test('activityToPhase maps correctly', () {
      expect(
        HypnogramBuilder.activityToPhase(ActivityLevel.silence),
        SleepPhaseType.deep,
      );
      expect(
        HypnogramBuilder.activityToPhase(ActivityLevel.lowActivity),
        SleepPhaseType.light,
      );
      expect(
        HypnogramBuilder.activityToPhase(ActivityLevel.mediumActivity),
        SleepPhaseType.rem,
      );
      expect(
        HypnogramBuilder.activityToPhase(ActivityLevel.highActivity),
        SleepPhaseType.awake,
      );
      expect(
        HypnogramBuilder.activityToPhase(ActivityLevel.snoring),
        SleepPhaseType.deep,
      );
    });

    test('Empty samples → empty phases', () {
      expect(builder.build([]), isEmpty);
    });

    test('All-silence session → single deep phase', () {
      final base = DateTime(2026, 1, 1, 23, 0);
      // 30 samples over 60 minutes (every 2 minutes)
      final samples = List.generate(
        30,
        (i) => makeSample(ActivityLevel.silence, base, i * 2),
      );

      final phases = builder.build(samples);
      expect(phases, isNotEmpty);
      // Should be all deep
      for (final p in phases) {
        expect(p.type, SleepPhaseType.deep);
      }
    });

    test('Alternating phases get smoothed by minimum duration', () {
      final base = DateTime(2026, 1, 1, 23, 0);
      // Pattern: 20 min silence, 5 min low, 20 min silence
      // The 5-min low is below minPhaseDuration (10 min) → should be smoothed to deep
      final samples = <SleepSample>[];

      // 0-19 min: silence (every 1 min to have enough samples per 5-min window)
      for (var i = 0; i < 20; i++) {
        samples.add(makeSample(ActivityLevel.silence, base, i));
      }
      // 20-24 min: low activity
      for (var i = 20; i < 25; i++) {
        samples.add(makeSample(ActivityLevel.lowActivity, base, i));
      }
      // 25-44 min: silence
      for (var i = 25; i < 45; i++) {
        samples.add(makeSample(ActivityLevel.silence, base, i));
      }

      final phases = builder.build(samples);

      // After smoothing the 5-min light phase should merge into deep
      for (final p in phases) {
        expect(p.type, SleepPhaseType.deep,
            reason: 'Short light phase should be smoothed to deep');
      }
    });

    test('Long distinct phases are preserved', () {
      final base = DateTime(2026, 1, 1, 23, 0);
      final samples = <SleepSample>[];

      // 0-29 min: silence → deep
      for (var i = 0; i < 30; i++) {
        samples.add(makeSample(ActivityLevel.silence, base, i));
      }
      // 30-59 min: low activity → light
      for (var i = 30; i < 60; i++) {
        samples.add(makeSample(ActivityLevel.lowActivity, base, i));
      }
      // 60-89 min: medium → REM
      for (var i = 60; i < 90; i++) {
        samples.add(makeSample(ActivityLevel.mediumActivity, base, i));
      }

      final phases = builder.build(samples);

      // Should have 3 distinct phases
      expect(phases.length, 3);
      expect(phases[0].type, SleepPhaseType.deep);
      expect(phases[1].type, SleepPhaseType.light);
      expect(phases[2].type, SleepPhaseType.rem);
    });

    test('Phases have correct time boundaries', () {
      final base = DateTime(2026, 1, 1, 23, 0);
      final samples = <SleepSample>[];

      for (var i = 0; i < 30; i++) {
        samples.add(makeSample(ActivityLevel.silence, base, i));
      }
      for (var i = 30; i < 60; i++) {
        samples.add(makeSample(ActivityLevel.lowActivity, base, i));
      }

      final phases = builder.build(samples);
      expect(phases.length, greaterThanOrEqualTo(2));

      // First phase starts at session start
      expect(phases.first.startTime, base);
      // Last phase ends at or after last sample
      expect(
        phases.last.endTime.isAfter(base.add(const Duration(minutes: 55))) ||
            phases.last.endTime.isAtSameMomentAs(
                base.add(const Duration(minutes: 60))),
        isTrue,
      );
    });
  });

  // -------------------------------------------------------------------------
  group('WakeDetector', () {
    final base = DateTime(2026, 1, 1, 6, 0);
    final windowStart = DateTime(2026, 1, 1, 6, 30);
    final windowEnd = DateTime(2026, 1, 1, 7, 0);

    test('Before wake window → false', () {
      final samples = [
        makeSample(ActivityLevel.silence, base, 0),
        makeSample(ActivityLevel.lowActivity, base, 1),
      ];
      expect(
        WakeDetector.shouldWake(
          recentSamples: samples,
          windowStart: windowStart,
          windowEnd: windowEnd,
          now: DateTime(2026, 1, 1, 6, 15), // before window
        ),
        isFalse,
      );
    });

    test('Past window end → force wake (true)', () {
      final samples = [
        makeSample(ActivityLevel.silence, base, 0),
        makeSample(ActivityLevel.silence, base, 1),
      ];
      expect(
        WakeDetector.shouldWake(
          recentSamples: samples,
          windowStart: windowStart,
          windowEnd: windowEnd,
          now: DateTime(2026, 1, 1, 7, 5), // past window
        ),
        isTrue,
      );
    });

    test('In window + light sleep → true', () {
      final samples = [
        makeSample(ActivityLevel.silence, base, 30),
        makeSample(ActivityLevel.lowActivity, base, 31),
      ];
      expect(
        WakeDetector.shouldWake(
          recentSamples: samples,
          windowStart: windowStart,
          windowEnd: windowEnd,
          now: DateTime(2026, 1, 1, 6, 35),
        ),
        isTrue,
      );
    });

    test('In window + deep sleep → false', () {
      final samples = [
        makeSample(ActivityLevel.silence, base, 30),
        makeSample(ActivityLevel.silence, base, 31),
      ];
      expect(
        WakeDetector.shouldWake(
          recentSamples: samples,
          windowStart: windowStart,
          windowEnd: windowEnd,
          now: DateTime(2026, 1, 1, 6, 35),
        ),
        isFalse,
      );
    });

    test('In window + transition from silence → medium → true', () {
      final samples = [
        makeSample(ActivityLevel.silence, base, 30),
        makeSample(ActivityLevel.mediumActivity, base, 31),
      ];
      expect(
        WakeDetector.shouldWake(
          recentSamples: samples,
          windowStart: windowStart,
          windowEnd: windowEnd,
          now: DateTime(2026, 1, 1, 6, 35),
        ),
        isTrue,
      );
    });

    test('Not enough samples → false', () {
      final samples = [
        makeSample(ActivityLevel.lowActivity, base, 31),
      ];
      expect(
        WakeDetector.shouldWake(
          recentSamples: samples,
          windowStart: windowStart,
          windowEnd: windowEnd,
          now: DateTime(2026, 1, 1, 6, 35),
        ),
        isFalse,
      );
    });
  });

  // -------------------------------------------------------------------------
  group('SleepScoreCalculator', () {
    test('Empty phases → 0', () {
      expect(
        SleepScoreCalculator.calculate(
          totalDuration: const Duration(hours: 8),
          phases: [],
          snoreSampleCount: 0,
          totalSampleCount: 0,
        ),
        0,
      );
    });

    test('Ideal night scores high (≥ 80)', () {
      final base = DateTime(2026, 1, 1, 23, 0);
      // 8 hours: 20% deep, 25% REM, 50% light, 5% awake
      final phases = [
        SleepPhase(
          type: SleepPhaseType.deep,
          startTime: base,
          endTime: base.add(const Duration(minutes: 96)), // 20%
        ),
        SleepPhase(
          type: SleepPhaseType.rem,
          startTime: base.add(const Duration(minutes: 96)),
          endTime: base.add(const Duration(minutes: 216)), // 25%
        ),
        SleepPhase(
          type: SleepPhaseType.light,
          startTime: base.add(const Duration(minutes: 216)),
          endTime: base.add(const Duration(minutes: 456)), // 50%
        ),
        SleepPhase(
          type: SleepPhaseType.awake,
          startTime: base.add(const Duration(minutes: 456)),
          endTime: base.add(const Duration(minutes: 480)), // 5%
        ),
      ];

      final score = SleepScoreCalculator.calculate(
        totalDuration: const Duration(hours: 8),
        phases: phases,
        snoreSampleCount: 2,
        totalSampleCount: 100,
      );
      expect(score, greaterThanOrEqualTo(80));
    });

    test('Short sleep scores lower', () {
      final base = DateTime(2026, 1, 1, 3, 0);
      final phases = [
        SleepPhase(
          type: SleepPhaseType.light,
          startTime: base,
          endTime: base.add(const Duration(hours: 4)),
        ),
      ];

      final score = SleepScoreCalculator.calculate(
        totalDuration: const Duration(hours: 4),
        phases: phases,
        snoreSampleCount: 0,
        totalSampleCount: 50,
      );
      expect(score, lessThan(60));
    });

    test('Heavy snoring reduces score', () {
      final base = DateTime(2026, 1, 1, 23, 0);
      final phases = [
        SleepPhase(
          type: SleepPhaseType.deep,
          startTime: base,
          endTime: base.add(const Duration(hours: 8)),
        ),
      ];

      final scoreNoSnore = SleepScoreCalculator.calculate(
        totalDuration: const Duration(hours: 8),
        phases: phases,
        snoreSampleCount: 0,
        totalSampleCount: 100,
      );
      final scoreHeavySnore = SleepScoreCalculator.calculate(
        totalDuration: const Duration(hours: 8),
        phases: phases,
        snoreSampleCount: 40,
        totalSampleCount: 100,
      );
      expect(scoreHeavySnore, lessThan(scoreNoSnore));
    });

    test('Score is clamped to 0–100', () {
      final base = DateTime(2026, 1, 1, 23, 0);
      // Mostly awake → heavy penalty
      final phases = [
        SleepPhase(
          type: SleepPhaseType.awake,
          startTime: base,
          endTime: base.add(const Duration(hours: 2)),
        ),
      ];

      final score = SleepScoreCalculator.calculate(
        totalDuration: const Duration(hours: 2),
        phases: phases,
        snoreSampleCount: 50,
        totalSampleCount: 50,
      );
      expect(score, greaterThanOrEqualTo(0));
      expect(score, lessThanOrEqualTo(100));
    });
  });

  // -------------------------------------------------------------------------
  group('AudioAnalysisService (with mock)', () {
    test('analyzeSample classifies silence correctly', () {
      final source = MockAudioSource();
      final service = AudioAnalysisService(source: source);

      final silence = generateSilence(sampleLength);
      final sample = service.analyzeSample(
        buffer: silence,
        sampleRate: sampleRate,
      );

      expect(sample.rms, 0.0);
      expect(sample.classification, ActivityLevel.silence);
    });

    test('analyzeSample classifies loud noise as high activity', () {
      final source = MockAudioSource();
      final service = AudioAnalysisService(source: source);

      final noise = generateNoise(length: sampleLength, amplitude: 0.8);
      final sample = service.analyzeSample(
        buffer: noise,
        sampleRate: sampleRate,
      );

      expect(sample.rms, greaterThan(0.25));
      expect(sample.classification, ActivityLevel.highActivity);
    });

    test('analyzeSample classifies snoring pattern', () {
      final source = MockAudioSource();
      final service = AudioAnalysisService(source: source);

      final snoring = generateSnoring(
        sampleRate: sampleRate,
        length: sampleLength,
      );
      final sample = service.analyzeSample(
        buffer: snoring,
        sampleRate: sampleRate,
      );

      expect(sample.classification, ActivityLevel.snoring);
    });

    test('analyzeSample classifies quiet noise as low activity', () {
      final source = MockAudioSource();
      final service = AudioAnalysisService(source: source);

      final quietNoise = generateNoise(length: sampleLength, amplitude: 0.08);
      final sample = service.analyzeSample(
        buffer: quietNoise,
        sampleRate: sampleRate,
      );

      // RMS of uniform noise ≈ amplitude / sqrt(3) ≈ 0.046
      expect(sample.classification, ActivityLevel.lowActivity);
    });

    test('startRecording and stopRecording produce a session', () async {
      final source = MockAudioSource();
      // Return silence on capture
      source.onCapture = (d) => generateSilence(
          (source.sampleRate * d.inMilliseconds / 1000).round());

      final service = AudioAnalysisService(
        source: source,
        config: const AudioAnalysisConfig(
          sampleInterval: Duration(milliseconds: 50),
        ),
      );

      await service.startRecording();
      expect(service.isRecording, isTrue);

      // Wait for a few samples
      await Future<void>.delayed(const Duration(milliseconds: 200));

      final session = await service.stopRecording();
      expect(service.isRecording, isFalse);
      expect(session.samples, isNotEmpty);
      expect(session.bedtime.isBefore(session.wakeTime), isTrue);

      service.dispose();
    });

    test('sampleStream emits samples during recording', () async {
      final source = MockAudioSource();
      source.onCapture = (d) => generateSilence(
          (source.sampleRate * d.inMilliseconds / 1000).round());

      final service = AudioAnalysisService(
        source: source,
        config: const AudioAnalysisConfig(
          sampleInterval: Duration(milliseconds: 50),
        ),
      );

      final collected = <SleepSample>[];
      final sub = service.sampleStream.listen(collected.add);

      await service.startRecording();
      await Future<void>.delayed(const Duration(milliseconds: 200));
      await service.stopRecording();

      expect(collected, isNotEmpty);

      await sub.cancel();
      service.dispose();
    });
  });

  // -------------------------------------------------------------------------
  group('Full pipeline: raw audio → session', () {
    test('Simulated night produces plausible session', () {
      final source = MockAudioSource();
      final service = AudioAnalysisService(source: source);
      final base = DateTime(2026, 1, 1, 23, 0);

      // Simulate a night with known audio patterns
      final nightSamples = <SleepSample>[];

      // Phase 1: Falling asleep — some movement (0–30 min)
      for (var i = 0; i < 30; i += 2) {
        final noise = generateNoise(length: sampleLength, amplitude: 0.12);
        final s = service.analyzeSample(
          buffer: noise,
          sampleRate: sampleRate,
          timestamp: base.add(Duration(minutes: i)),
        );
        nightSamples.add(s);
      }

      // Phase 2: Deep sleep — silence (30–150 min)
      for (var i = 30; i < 150; i += 2) {
        final silence = generateSilence(sampleLength);
        final s = service.analyzeSample(
          buffer: silence,
          sampleRate: sampleRate,
          timestamp: base.add(Duration(minutes: i)),
        );
        nightSamples.add(s);
      }

      // Phase 3: Snoring (150–210 min)
      for (var i = 150; i < 210; i += 2) {
        final snoring = generateSnoring(
          sampleRate: sampleRate,
          length: sampleLength,
        );
        final s = service.analyzeSample(
          buffer: snoring,
          sampleRate: sampleRate,
          timestamp: base.add(Duration(minutes: i)),
        );
        nightSamples.add(s);
      }

      // Phase 4: REM — some movement (210–300 min)
      for (var i = 210; i < 300; i += 2) {
        final noise = generateNoise(length: sampleLength, amplitude: 0.18);
        final s = service.analyzeSample(
          buffer: noise,
          sampleRate: sampleRate,
          timestamp: base.add(Duration(minutes: i)),
        );
        nightSamples.add(s);
      }

      // Phase 5: Light sleep → waking (300–420 min)
      for (var i = 300; i < 420; i += 2) {
        final quietNoise =
            generateNoise(length: sampleLength, amplitude: 0.06);
        final s = service.analyzeSample(
          buffer: quietNoise,
          sampleRate: sampleRate,
          timestamp: base.add(Duration(minutes: i)),
        );
        nightSamples.add(s);
      }

      // Build hypnogram
      const builder = HypnogramBuilder();
      final phases = builder.build(nightSamples);

      expect(phases, isNotEmpty);
      expect(phases.length, greaterThanOrEqualTo(2));

      // Verify we get multiple phase types
      final phaseTypes = phases.map((p) => p.type).toSet();
      expect(phaseTypes.length, greaterThanOrEqualTo(2));

      // Calculate score
      final totalDuration = nightSamples.last.timestamp
          .difference(nightSamples.first.timestamp);
      final snoreCount = nightSamples
          .where((s) => s.classification == ActivityLevel.snoring)
          .length;

      final score = SleepScoreCalculator.calculate(
        totalDuration: totalDuration,
        phases: phases,
        snoreSampleCount: snoreCount,
        totalSampleCount: nightSamples.length,
      );

      // 7-hour night with some deep sleep → reasonable score
      expect(score, greaterThan(30));
      expect(score, lessThanOrEqualTo(100));

      service.dispose();
    });
  });
}
