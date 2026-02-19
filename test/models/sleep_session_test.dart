import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/models/sleep_phase.dart';
import 'package:sleepwise/models/sleep_session.dart';

void main() {
  group('SleepSession', () {
    late DateTime bedtime;
    late DateTime wakeTime;

    setUp(() {
      bedtime = DateTime(2026, 1, 15, 23, 0);
      wakeTime = DateTime(2026, 1, 16, 7, 0);
    });

    test('computes duration correctly', () {
      final session = SleepSession(bedtime: bedtime, wakeTime: wakeTime);
      expect(session.duration.inHours, 8);
    });

    test('computes hoursSlept correctly', () {
      final session = SleepSession(bedtime: bedtime, wakeTime: wakeTime);
      expect(session.hoursSlept, 8.0);
    });

    test('computes hoursSlept with fractional hours', () {
      final session = SleepSession(
        bedtime: bedtime,
        wakeTime: DateTime(2026, 1, 16, 6, 30),
      );
      expect(session.hoursSlept, 7.5);
    });

    test('default values are set correctly', () {
      final session = SleepSession(bedtime: bedtime, wakeTime: wakeTime);
      expect(session.phases, isEmpty);
      expect(session.samples, isEmpty);
      expect(session.qualityRating, 0);
      expect(session.score, 0);
      expect(session.snorePercentage, 0);
      expect(session.notes, isNull);
    });

    test('deepSleepPercent returns 0 with no phases', () {
      final session = SleepSession(bedtime: bedtime, wakeTime: wakeTime);
      expect(session.deepSleepPercent, 0);
    });

    test('remPercent returns 0 with no phases', () {
      final session = SleepSession(bedtime: bedtime, wakeTime: wakeTime);
      expect(session.remPercent, 0);
    });

    test('deepSleepPercent calculates correctly with phases', () {
      final phases = [
        SleepPhase(
          type: SleepPhaseType.deep,
          startTime: DateTime(2026, 1, 15, 23, 0),
          endTime: DateTime(2026, 1, 16, 1, 0), // 2 hours deep
        ),
        SleepPhase(
          type: SleepPhaseType.light,
          startTime: DateTime(2026, 1, 16, 1, 0),
          endTime: DateTime(2026, 1, 16, 5, 0), // 4 hours light
        ),
        SleepPhase(
          type: SleepPhaseType.rem,
          startTime: DateTime(2026, 1, 16, 5, 0),
          endTime: DateTime(2026, 1, 16, 7, 0), // 2 hours REM
        ),
      ];

      final session = SleepSession(
        bedtime: bedtime,
        wakeTime: wakeTime,
        phases: phases,
      );

      // 2 hours deep out of 8 total = 25%
      expect(session.deepSleepPercent, 25.0);
    });

    test('remPercent calculates correctly with phases', () {
      final phases = [
        SleepPhase(
          type: SleepPhaseType.light,
          startTime: DateTime(2026, 1, 15, 23, 0),
          endTime: DateTime(2026, 1, 16, 3, 0), // 4 hours
        ),
        SleepPhase(
          type: SleepPhaseType.rem,
          startTime: DateTime(2026, 1, 16, 3, 0),
          endTime: DateTime(2026, 1, 16, 5, 0), // 2 hours
        ),
        SleepPhase(
          type: SleepPhaseType.light,
          startTime: DateTime(2026, 1, 16, 5, 0),
          endTime: DateTime(2026, 1, 16, 7, 0), // 2 hours
        ),
      ];

      final session = SleepSession(
        bedtime: bedtime,
        wakeTime: wakeTime,
        phases: phases,
      );

      // 2 hours REM out of 8 total = 25%
      expect(session.remPercent, 25.0);
    });

    test('phase percent handles zero duration session', () {
      final sameMoment = DateTime(2026, 1, 15, 23, 0);
      final session = SleepSession(
        bedtime: sameMoment,
        wakeTime: sameMoment,
        phases: [
          SleepPhase(
            type: SleepPhaseType.deep,
            startTime: sameMoment,
            endTime: sameMoment,
          ),
        ],
      );
      expect(session.deepSleepPercent, 0);
    });

    test('stores custom values', () {
      final session = SleepSession(
        bedtime: bedtime,
        wakeTime: wakeTime,
        qualityRating: 4,
        score: 85,
        snorePercentage: 12,
        notes: 'Good night',
      );
      expect(session.qualityRating, 4);
      expect(session.score, 85);
      expect(session.snorePercentage, 12);
      expect(session.notes, 'Good night');
    });

    test('multiple deep phases accumulate', () {
      final phases = [
        SleepPhase(
          type: SleepPhaseType.deep,
          startTime: DateTime(2026, 1, 15, 23, 0),
          endTime: DateTime(2026, 1, 16, 0, 0), // 1 hr
        ),
        SleepPhase(
          type: SleepPhaseType.light,
          startTime: DateTime(2026, 1, 16, 0, 0),
          endTime: DateTime(2026, 1, 16, 3, 0), // 3 hr
        ),
        SleepPhase(
          type: SleepPhaseType.deep,
          startTime: DateTime(2026, 1, 16, 3, 0),
          endTime: DateTime(2026, 1, 16, 5, 0), // 2 hr
        ),
        SleepPhase(
          type: SleepPhaseType.light,
          startTime: DateTime(2026, 1, 16, 5, 0),
          endTime: DateTime(2026, 1, 16, 7, 0), // 2 hr
        ),
      ];

      final session = SleepSession(
        bedtime: bedtime,
        wakeTime: wakeTime,
        phases: phases,
      );

      // 3 hours deep out of 8 = 37.5%
      expect(session.deepSleepPercent, 37.5);
    });
  });
}
