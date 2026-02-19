import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../models/sleep_sample.dart';
import '../models/sleep_session.dart';
import 'audio_analysis_service.dart';
import 'record_audio_source.dart';

/// Orchestrates a full sleep tracking session:
/// - Starts/stops the real microphone via [AudioAnalysisService]
/// - Manages Android foreground service & notification
/// - Keeps the device awake via WakeLock
/// - Provides a stream of analysis results for UI visualization
/// - Logs status every sample interval
class SleepTrackingService {
  static const _channel = MethodChannel('com.sleepwise/tracking');

  AudioAnalysisService? _analysisService;
  RecordAudioSource? _audioSource;
  StreamSubscription<SleepSample>? _sampleSub;
  bool _isTracking = false;
  DateTime? _startTime;

  /// Stream controller for UI to listen to live samples.
  final _liveSampleController = StreamController<SleepSample>.broadcast();
  Stream<SleepSample> get liveSamples => _liveSampleController.stream;

  /// Latest sample for UI visualization.
  SleepSample? _latestSample;
  SleepSample? get latestSample => _latestSample;

  bool get isTracking => _isTracking;

  /// Start a full sleep tracking session.
  Future<void> startTracking() async {
    if (_isTracking) return;

    _startTime = DateTime.now();
    _isTracking = true;

    // 1. Enable wakelock
    try {
      await WakelockPlus.enable();
    } catch (_) {}

    // 2. Start Android foreground service
    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod('startService');
      } catch (e) {
        dev.log('[SleepTracking] Foreground service start failed: $e');
      }
    }

    // 3. Create audio source and analysis service
    _audioSource = RecordAudioSource();
    _analysisService = AudioAnalysisService(source: _audioSource!);

    // 4. Listen to samples for live UI + logging
    _sampleSub = _analysisService!.sampleStream.listen(_onNewSample);

    // 5. Start recording
    await _analysisService!.startRecording();

    dev.log('[SleepTracking] ▶ Session started at $_startTime');
  }

  /// Stop tracking and return the completed session.
  Future<SleepSession> stopTracking() async {
    if (!_isTracking || _analysisService == null) {
      return SleepSession(
        bedtime: _startTime ?? DateTime.now(),
        wakeTime: DateTime.now(),
      );
    }

    _isTracking = false;

    // 1. Stop recording and get session
    final session = await _analysisService!.stopRecording();

    dev.log('[SleepTracking] ⏹ Session stopped. '
        'Duration: ${session.duration.inMinutes} min, '
        'Score: ${session.score}, '
        'Phases: ${session.phases.length}, '
        'Samples: ${session.samples.length}, '
        'Snore: ${session.snorePercentage}%');

    // 2. Clean up subscriptions
    await _sampleSub?.cancel();
    _sampleSub = null;

    // 3. Dispose audio source
    await _audioSource?.dispose();
    _audioSource = null;
    _analysisService?.dispose();
    _analysisService = null;

    // 4. Stop Android foreground service
    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod('stopService');
      } catch (_) {}
    }

    // 5. Release wakelock
    try {
      await WakelockPlus.disable();
    } catch (_) {}

    return session;
  }

  /// Check if it's time to wake the user within the given alarm window.
  bool shouldWakeNow({
    required DateTime windowStart,
    required DateTime windowEnd,
  }) {
    return _analysisService?.shouldWakeNow(
          windowStart: windowStart,
          windowEnd: windowEnd,
        ) ??
        false;
  }

  void _onNewSample(SleepSample sample) {
    _latestSample = sample;
    _liveSampleController.add(sample);

    // Console logging every sample (every 30s by default)
    final elapsed = _startTime != null
        ? DateTime.now().difference(_startTime!).inSeconds
        : 0;

    dev.log(
      '[SleepTracking] ${_formatTime(sample.timestamp)} '
      '(+${elapsed}s) '
      '│ RMS: ${sample.rms.toStringAsFixed(4)} '
      '│ Peak: ${sample.peak.toStringAsFixed(4)} '
      '│ ZCR: ${sample.zcr.toStringAsFixed(4)} '
      '│ Bands: L=${sample.bands.low.toStringAsFixed(2)} '
      'M=${sample.bands.mid.toStringAsFixed(2)} '
      'H=${sample.bands.high.toStringAsFixed(2)} '
      '│ → ${sample.classification.name.toUpperCase()}',
    );
  }

  static String _formatTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:'
      '${t.minute.toString().padLeft(2, '0')}:'
      '${t.second.toString().padLeft(2, '0')}';

  void dispose() {
    _sampleSub?.cancel();
    _analysisService?.dispose();
    _liveSampleController.close();
  }
}
