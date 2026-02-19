import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/core/utils/date_time_utils.dart';

void main() {
  group('DateTimeUtils.formatTime', () {
    test('formats morning time correctly', () {
      final dt = DateTime(2026, 1, 15, 7, 30);
      expect(DateTimeUtils.formatTime(dt), '07:30');
    });

    test('formats midnight correctly', () {
      final dt = DateTime(2026, 1, 15, 0, 0);
      expect(DateTimeUtils.formatTime(dt), '00:00');
    });

    test('formats noon correctly', () {
      final dt = DateTime(2026, 1, 15, 12, 0);
      expect(DateTimeUtils.formatTime(dt), '12:00');
    });

    test('formats with leading zeros', () {
      final dt = DateTime(2026, 1, 15, 5, 3);
      expect(DateTimeUtils.formatTime(dt), '05:03');
    });

    test('formats 23:59 correctly', () {
      final dt = DateTime(2026, 1, 15, 23, 59);
      expect(DateTimeUtils.formatTime(dt), '23:59');
    });
  });

  group('DateTimeUtils.formatDate', () {
    test('formats date correctly', () {
      final dt = DateTime(2026, 2, 19);
      final result = DateTimeUtils.formatDate(dt);
      expect(result, contains('19'));
      expect(result, contains('2026'));
    });
  });

  group('DateTimeUtils.formatDuration', () {
    test('formats hours and minutes', () {
      expect(DateTimeUtils.formatDuration(const Duration(hours: 7, minutes: 30)), '7h 30m');
    });

    test('formats only hours', () {
      expect(DateTimeUtils.formatDuration(const Duration(hours: 8)), '8h 0m');
    });

    test('formats zero duration', () {
      expect(DateTimeUtils.formatDuration(Duration.zero), '0h 0m');
    });

    test('formats large durations', () {
      expect(DateTimeUtils.formatDuration(const Duration(hours: 10, minutes: 45)), '10h 45m');
    });
  });

  group('DateTimeUtils.formatSleepDuration', () {
    test('formats hours and minutes', () {
      expect(
        DateTimeUtils.formatSleepDuration(const Duration(hours: 7, minutes: 30)),
        '7 hr 30 min',
      );
    });

    test('formats only minutes when less than 1 hour', () {
      expect(
        DateTimeUtils.formatSleepDuration(const Duration(minutes: 45)),
        '45 min',
      );
    });

    test('formats only hours when no minutes', () {
      expect(
        DateTimeUtils.formatSleepDuration(const Duration(hours: 8)),
        '8 hr',
      );
    });

    test('formats zero minutes as "0 min"', () {
      expect(
        DateTimeUtils.formatSleepDuration(Duration.zero),
        '0 min',
      );
    });
  });

  group('DateTimeUtils.timeDifference', () {
    test('same day wake after bed', () {
      final bedtime = DateTime(2026, 1, 15, 22, 0);
      final wakeTime = DateTime(2026, 1, 15, 23, 30);
      expect(DateTimeUtils.timeDifference(bedtime, wakeTime).inMinutes, 90);
    });

    test('next day wake after bed', () {
      final bedtime = DateTime(2026, 1, 15, 23, 0);
      final wakeTime = DateTime(2026, 1, 16, 7, 0);
      expect(DateTimeUtils.timeDifference(bedtime, wakeTime).inHours, 8);
    });

    test('adds day when wake is before bed (cross-midnight)', () {
      final bedtime = DateTime(2026, 1, 15, 23, 0);
      // wakeTime earlier in the day — simulates next-day wake
      final wakeTime = DateTime(2026, 1, 15, 7, 0);
      final diff = DateTimeUtils.timeDifference(bedtime, wakeTime);
      expect(diff.inHours, 8);
    });

    test('zero difference when same time', () {
      final time = DateTime(2026, 1, 15, 23, 0);
      expect(DateTimeUtils.timeDifference(time, time), Duration.zero);
    });
  });
}
