/// Classification of audio activity within a single sample.
enum ActivityLevel {
  silence,
  lowActivity,
  mediumActivity,
  highActivity,
  snoring,
}

/// Frequency band energies from spectral analysis.
class FrequencyBands {
  /// 0–250 Hz (snoring, deep rumble)
  final double low;

  /// 250–1000 Hz (voice, movement)
  final double mid;

  /// 1000–4000 Hz (rustling, breathing)
  final double high;

  /// 4000+ Hz (clicks, sharp noises)
  final double veryHigh;

  const FrequencyBands({
    required this.low,
    required this.mid,
    required this.high,
    required this.veryHigh,
  });

  @override
  String toString() =>
      'FrequencyBands(low: ${low.toStringAsFixed(4)}, mid: ${mid.toStringAsFixed(4)}, '
      'high: ${high.toStringAsFixed(4)}, veryHigh: ${veryHigh.toStringAsFixed(4)})';
}

/// A single audio sample captured during sleep tracking.
class SleepSample {
  final DateTime timestamp;

  /// Root mean square amplitude (average loudness), 0.0–1.0.
  final double rms;

  /// Peak amplitude in the sample, 0.0–1.0.
  final double peak;

  /// Zero-crossing rate — rough frequency proxy, 0.0–1.0 normalized.
  final double zcr;

  /// Spectral energy split into frequency bands.
  final FrequencyBands bands;

  /// Heuristic classification result.
  final ActivityLevel classification;

  const SleepSample({
    required this.timestamp,
    required this.rms,
    required this.peak,
    required this.zcr,
    required this.bands,
    required this.classification,
  });

  @override
  String toString() =>
      'SleepSample(${timestamp.toIso8601String()}, rms: ${rms.toStringAsFixed(4)}, '
      'classification: ${classification.name})';
}
