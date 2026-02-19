import 'dart:async';
import 'dart:typed_data';

import 'package:record/record.dart';

import 'audio_analysis_service.dart';

/// Real microphone [AudioSource] implementation using the `record` package.
///
/// Streams PCM 16-bit audio from the device microphone and converts it to
/// normalized Float64List buffers for analysis.
class RecordAudioSource implements AudioSource {
  static const int _kSampleRate = 16000;
  static const int _kBytesPerSample = 2; // PCM 16-bit

  final AudioRecorder _recorder = AudioRecorder();

  StreamSubscription<List<int>>? _streamSub;
  final List<int> _buffer = [];
  bool _isActive = false;

  @override
  int get sampleRate => _kSampleRate;

  @override
  Future<void> start() async {
    if (_isActive) return;

    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      throw StateError('Microphone permission not granted');
    }

    // Start streaming PCM data
    final stream = await _recorder.startStream(RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      sampleRate: _kSampleRate,
      numChannels: 1,
      autoGain: true,
      echoCancel: false,
      noiseSuppress: true,
    ));

    _isActive = true;
    _buffer.clear();

    _streamSub = stream.listen(
      (chunk) => _buffer.addAll(chunk),
      onError: (_) {},
    );
  }

  @override
  Future<void> stop() async {
    _isActive = false;
    await _streamSub?.cancel();
    _streamSub = null;
    _buffer.clear();

    try {
      await _recorder.stop();
    } catch (_) {}
  }

  @override
  Future<Float64List> capture(Duration duration) async {
    if (!_isActive) {
      return Float64List(0);
    }

    final neededSamples = (duration.inMilliseconds * _kSampleRate / 1000).round();
    final neededBytes = neededSamples * _kBytesPerSample;

    // Wait until we have enough data (with timeout)
    final deadline = DateTime.now().add(duration + const Duration(seconds: 2));
    while (_buffer.length < neededBytes) {
      if (DateTime.now().isAfter(deadline)) break;
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }

    // Extract the bytes we need
    final takeBytes = _buffer.length < neededBytes ? _buffer.length : neededBytes;
    final rawBytes = _buffer.sublist(0, takeBytes);
    _buffer.removeRange(0, takeBytes);

    // Convert PCM 16-bit LE → normalized Float64 [-1.0, 1.0]
    return _pcm16ToFloat64(rawBytes);
  }

  /// Convert raw PCM 16-bit little-endian bytes to normalized doubles.
  static Float64List _pcm16ToFloat64(List<int> bytes) {
    final sampleCount = bytes.length ~/ _kBytesPerSample;
    final result = Float64List(sampleCount);

    for (var i = 0; i < sampleCount; i++) {
      final offset = i * _kBytesPerSample;
      // Little-endian 16-bit signed
      var sample = bytes[offset] | (bytes[offset + 1] << 8);
      if (sample >= 0x8000) sample -= 0x10000; // sign extend
      result[i] = sample / 32768.0;
    }

    return result;
  }

  Future<void> dispose() async {
    await stop();
    _recorder.dispose();
  }
}
