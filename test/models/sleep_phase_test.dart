import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/models/sleep_phase.dart';

void main() {
  group('SleepPhaseType', () {
    test('has all four types', () {
      expect(SleepPhaseType.values.length, 4);
      expect(SleepPhaseType.values, contains(SleepPhaseType.awake));
      expect(SleepPhaseType.values, contains(SleepPhaseType.light));
      expect(SleepPhaseType.values, contains(SleepPhaseType.deep));
      expect(SleepPhaseType.values, contains(SleepPhaseType.rem));
    });

    test('indices are in correct order', () {
      expect(SleepPhaseType.awake.index, 0);
      expect(SleepPhaseType.light.index, 1);
      expect(SleepPhaseType.deep.index, 2);
      expect(SleepPhaseType.rem.index, 3);
    });
  });

  group('SleepPhase', () {
    test('computes duration correctly', () {
      final start = DateTime(2026, 1, 15, 23, 0);
      final end = DateTime(2026, 1, 16, 1, 30);
      final phase = SleepPhase(
        type: SleepPhaseType.deep,
        startTime: start,
        endTime: end,
      );
      expect(phase.duration.inMinutes, 150);
      expect(phase.duration.inHours, 2);
    });

    test('zero duration when start equals end', () {
      final time = DateTime(2026, 1, 15, 23, 0);
      final phase = SleepPhase(
        type: SleepPhaseType.light,
        startTime: time,
        endTime: time,
      );
      expect(phase.duration, Duration.zero);
    });

    test('stores type correctly', () {
      final phase = SleepPhase(
        type: SleepPhaseType.rem,
        startTime: DateTime(2026, 1, 15, 2, 0),
        endTime: DateTime(2026, 1, 15, 2, 30),
      );
      expect(phase.type, SleepPhaseType.rem);
    });

    test('stores start and end times correctly', () {
      final start = DateTime(2026, 2, 10, 0, 0);
      final end = DateTime(2026, 2, 10, 1, 0);
      final phase = SleepPhase(
        type: SleepPhaseType.awake,
        startTime: start,
        endTime: end,
      );
      expect(phase.startTime, start);
      expect(phase.endTime, end);
    });
  });
}
