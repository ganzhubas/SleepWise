import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/data/models/sleep_session_model.dart';

void main() {
  group('SleepPhaseModel', () {
    test('stores properties correctly', () {
      final start = DateTime(2026, 1, 15, 23, 0);
      final end = DateTime(2026, 1, 16, 1, 0);
      final model = SleepPhaseModel(
        type: 2, // deep
        startTime: start,
        endTime: end,
      );
      expect(model.type, 2);
      expect(model.startTime, start);
      expect(model.endTime, end);
    });

    test('computes duration correctly', () {
      final model = SleepPhaseModel(
        type: 1,
        startTime: DateTime(2026, 1, 15, 23, 0),
        endTime: DateTime(2026, 1, 16, 0, 30),
      );
      expect(model.duration.inMinutes, 90);
    });

    test('zero duration when same times', () {
      final t = DateTime(2026, 1, 15, 23, 0);
      final model = SleepPhaseModel(type: 0, startTime: t, endTime: t);
      expect(model.duration, Duration.zero);
    });
  });

  group('SleepSessionModel', () {
    test('stores all properties', () {
      final date = DateTime(2026, 1, 15);
      final bedtime = DateTime(2026, 1, 15, 23, 0);
      final wakeTime = DateTime(2026, 1, 16, 7, 0);
      final phases = [
        SleepPhaseModel(
          type: 1,
          startTime: bedtime,
          endTime: wakeTime,
        ),
      ];

      final model = SleepSessionModel(
        id: 'test-123',
        date: date,
        bedtime: bedtime,
        wakeTime: wakeTime,
        score: 85,
        snorePercent: 10,
        hoursSlept: 8.0,
        bedtimeHour: 23.0,
        awakenings: 2,
        phases: phases,
      );

      expect(model.id, 'test-123');
      expect(model.date, date);
      expect(model.bedtime, bedtime);
      expect(model.wakeTime, wakeTime);
      expect(model.score, 85);
      expect(model.snorePercent, 10);
      expect(model.hoursSlept, 8.0);
      expect(model.bedtimeHour, 23.0);
      expect(model.awakenings, 2);
      expect(model.phases.length, 1);
    });

    test('computes duration correctly', () {
      final model = SleepSessionModel(
        id: 'test',
        date: DateTime(2026, 1, 15),
        bedtime: DateTime(2026, 1, 15, 23, 0),
        wakeTime: DateTime(2026, 1, 16, 7, 30),
        score: 80,
        snorePercent: 5,
        hoursSlept: 8.5,
        bedtimeHour: 23.0,
        awakenings: 1,
        phases: [],
      );
      expect(model.duration.inMinutes, 510); // 8h 30m
    });
  });

  group('SleepPhaseModelAdapter', () {
    test('has correct typeId', () {
      final adapter = SleepPhaseModelAdapter();
      expect(adapter.typeId, sleepPhaseModelTypeId);
      expect(adapter.typeId, 1);
    });
  });

  group('SleepSessionModelAdapter', () {
    test('has correct typeId', () {
      final adapter = SleepSessionModelAdapter();
      expect(adapter.typeId, sleepSessionModelTypeId);
      expect(adapter.typeId, 0);
    });
  });

  group('Type IDs are unique', () {
    test('no duplicate type IDs', () {
      final ids = {
        sleepSessionModelTypeId,
        sleepPhaseModelTypeId,
      };
      expect(ids.length, 2, reason: 'Type IDs must be unique');
    });
  });
}
