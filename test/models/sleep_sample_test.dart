import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/models/sleep_sample.dart';

void main() {
  group('ActivityLevel', () {
    test('has all five levels', () {
      expect(ActivityLevel.values.length, 5);
      expect(ActivityLevel.values, contains(ActivityLevel.silence));
      expect(ActivityLevel.values, contains(ActivityLevel.lowActivity));
      expect(ActivityLevel.values, contains(ActivityLevel.mediumActivity));
      expect(ActivityLevel.values, contains(ActivityLevel.highActivity));
      expect(ActivityLevel.values, contains(ActivityLevel.snoring));
    });

    test('indices are in correct order', () {
      expect(ActivityLevel.silence.index, 0);
      expect(ActivityLevel.lowActivity.index, 1);
      expect(ActivityLevel.mediumActivity.index, 2);
      expect(ActivityLevel.highActivity.index, 3);
      expect(ActivityLevel.snoring.index, 4);
    });
  });

  group('FrequencyBands', () {
    test('stores values correctly', () {
      const bands = FrequencyBands(
        low: 0.5,
        mid: 0.3,
        high: 0.15,
        veryHigh: 0.05,
      );
      expect(bands.low, 0.5);
      expect(bands.mid, 0.3);
      expect(bands.high, 0.15);
      expect(bands.veryHigh, 0.05);
    });

    test('toString formats correctly', () {
      const bands = FrequencyBands(
        low: 0.1234,
        mid: 0.5678,
        high: 0.9012,
        veryHigh: 0.3456,
      );
      final str = bands.toString();
      expect(str, contains('0.1234'));
      expect(str, contains('0.5678'));
      expect(str, contains('0.9012'));
      expect(str, contains('0.3456'));
      expect(str, startsWith('FrequencyBands('));
    });

    test('supports zero values', () {
      const bands = FrequencyBands(
        low: 0.0,
        mid: 0.0,
        high: 0.0,
        veryHigh: 0.0,
      );
      expect(bands.low, 0.0);
      expect(bands.mid, 0.0);
      expect(bands.high, 0.0);
      expect(bands.veryHigh, 0.0);
    });
  });

  group('SleepSample', () {
    test('stores all properties', () {
      final ts = DateTime(2026, 1, 15, 1, 30);
      const bands = FrequencyBands(
        low: 0.4,
        mid: 0.3,
        high: 0.2,
        veryHigh: 0.1,
      );
      final sample = SleepSample(
        timestamp: ts,
        rms: 0.05,
        peak: 0.1,
        zcr: 0.2,
        bands: bands,
        classification: ActivityLevel.silence,
      );

      expect(sample.timestamp, ts);
      expect(sample.rms, 0.05);
      expect(sample.peak, 0.1);
      expect(sample.zcr, 0.2);
      expect(sample.bands.low, 0.4);
      expect(sample.classification, ActivityLevel.silence);
    });

    test('toString includes timestamp and classification', () {
      final sample = SleepSample(
        timestamp: DateTime(2026, 1, 15, 1, 30),
        rms: 0.1234,
        peak: 0.2,
        zcr: 0.3,
        bands: const FrequencyBands(
          low: 0.25,
          mid: 0.25,
          high: 0.25,
          veryHigh: 0.25,
        ),
        classification: ActivityLevel.snoring,
      );

      final str = sample.toString();
      expect(str, contains('SleepSample('));
      expect(str, contains('0.1234'));
      expect(str, contains('snoring'));
    });

    test('all classification types can be assigned', () {
      for (final level in ActivityLevel.values) {
        final sample = SleepSample(
          timestamp: DateTime(2026, 1, 15),
          rms: 0.0,
          peak: 0.0,
          zcr: 0.0,
          bands: const FrequencyBands(low: 0, mid: 0, high: 0, veryHigh: 0),
          classification: level,
        );
        expect(sample.classification, level);
      }
    });
  });
}
