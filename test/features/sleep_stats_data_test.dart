import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/data/models/sleep_session_model.dart';
import 'package:sleepwise/features/statistics/models/sleep_stats_data.dart';

void main() {
  group('DayStat', () {
    test('stores all properties', () {
      final stat = DayStat(
        date: DateTime(2026, 2, 10),
        score: 85,
        hoursSlept: 7.5,
        bedtimeHour: 23.25,
        snorePercent: 8,
        awakenings: 2,
      );
      expect(stat.date, DateTime(2026, 2, 10));
      expect(stat.score, 85);
      expect(stat.hoursSlept, 7.5);
      expect(stat.bedtimeHour, 23.25);
      expect(stat.snorePercent, 8);
      expect(stat.awakenings, 2);
    });
  });

  group('SleepStatsData', () {
    test('has 14 days of data', () {
      expect(SleepStatsData.days.length, 14);
    });

    test('all scores are in 0-100 range', () {
      for (final day in SleepStatsData.days) {
        expect(day.score, greaterThanOrEqualTo(0));
        expect(day.score, lessThanOrEqualTo(100));
      }
    });

    test('all snore percentages are in 0-100 range', () {
      for (final day in SleepStatsData.days) {
        expect(day.snorePercent, greaterThanOrEqualTo(0));
        expect(day.snorePercent, lessThanOrEqualTo(100));
      }
    });

    test('all hoursSlept are positive', () {
      for (final day in SleepStatsData.days) {
        expect(day.hoursSlept, greaterThan(0));
      }
    });

    test('dates are in chronological order', () {
      for (var i = 1; i < SleepStatsData.days.length; i++) {
        expect(
          SleepStatsData.days[i].date.isAfter(SleepStatsData.days[i - 1].date),
          true,
        );
      }
    });

    group('lastDays', () {
      test('returns requested number of days', () {
        expect(SleepStatsData.lastDays(7).length, 7);
        expect(SleepStatsData.lastDays(3).length, 3);
      });

      test('returns all days when n >= total', () {
        expect(SleepStatsData.lastDays(14).length, 14);
        expect(SleepStatsData.lastDays(100).length, 14);
      });

      test('returns most recent days', () {
        final last7 = SleepStatsData.lastDays(7);
        expect(last7.first.date, DateTime(2026, 2, 9));
        expect(last7.last.date, DateTime(2026, 2, 15));
      });
    });

    group('averageScore', () {
      test('returns 0 for empty list', () {
        expect(SleepStatsData.averageScore([]), 0);
      });

      test('calculates average correctly', () {
        final data = [
          DayStat(date: DateTime(2026, 2, 1), score: 80, hoursSlept: 7, bedtimeHour: 23, snorePercent: 5, awakenings: 1),
          DayStat(date: DateTime(2026, 2, 2), score: 60, hoursSlept: 7, bedtimeHour: 23, snorePercent: 5, awakenings: 1),
        ];
        expect(SleepStatsData.averageScore(data), 70.0);
      });

      test('single entry returns its score', () {
        final data = [
          DayStat(date: DateTime(2026, 2, 1), score: 85, hoursSlept: 7, bedtimeHour: 23, snorePercent: 5, awakenings: 1),
        ];
        expect(SleepStatsData.averageScore(data), 85.0);
      });
    });

    group('averageHours', () {
      test('returns 0 for empty list', () {
        expect(SleepStatsData.averageHours([]), 0);
      });

      test('calculates average hours correctly', () {
        final data = [
          DayStat(date: DateTime(2026, 2, 1), score: 80, hoursSlept: 6.0, bedtimeHour: 23, snorePercent: 5, awakenings: 1),
          DayStat(date: DateTime(2026, 2, 2), score: 80, hoursSlept: 8.0, bedtimeHour: 23, snorePercent: 5, awakenings: 1),
        ];
        expect(SleepStatsData.averageHours(data), 7.0);
      });
    });

    group('averageBedtime', () {
      test('returns 0 for empty list', () {
        expect(SleepStatsData.averageBedtime([]), 0);
      });

      test('calculates average bedtime for before-midnight times', () {
        final data = [
          DayStat(date: DateTime(2026, 2, 1), score: 80, hoursSlept: 7, bedtimeHour: 23.0, snorePercent: 5, awakenings: 1),
          DayStat(date: DateTime(2026, 2, 2), score: 80, hoursSlept: 7, bedtimeHour: 23.5, snorePercent: 5, awakenings: 1),
        ];
        expect(SleepStatsData.averageBedtime(data), 23.25);
      });

      test('handles cross-midnight bedtimes', () {
        final data = [
          DayStat(date: DateTime(2026, 2, 1), score: 80, hoursSlept: 7, bedtimeHour: 23.0, snorePercent: 5, awakenings: 1),
          DayStat(date: DateTime(2026, 2, 2), score: 80, hoursSlept: 7, bedtimeHour: 1.0, snorePercent: 5, awakenings: 1),
        ];
        // 23.0 and 1.0 (which becomes 25.0) → average 24.0 → 0.0
        expect(SleepStatsData.averageBedtime(data), 0.0);
      });
    });

    group('averageSnore', () {
      test('returns 0 for empty list', () {
        expect(SleepStatsData.averageSnore([]), 0);
      });

      test('calculates average snore percent', () {
        final data = [
          DayStat(date: DateTime(2026, 2, 1), score: 80, hoursSlept: 7, bedtimeHour: 23, snorePercent: 10, awakenings: 1),
          DayStat(date: DateTime(2026, 2, 2), score: 80, hoursSlept: 7, bedtimeHour: 23, snorePercent: 20, awakenings: 1),
        ];
        expect(SleepStatsData.averageSnore(data), 15.0);
      });
    });

    group('bestDay', () {
      test('returns null for empty list', () {
        expect(SleepStatsData.bestDay([]), isNull);
      });

      test('returns day with highest score', () {
        final data = [
          DayStat(date: DateTime(2026, 2, 1), score: 70, hoursSlept: 7, bedtimeHour: 23, snorePercent: 5, awakenings: 1),
          DayStat(date: DateTime(2026, 2, 2), score: 90, hoursSlept: 8, bedtimeHour: 23, snorePercent: 3, awakenings: 0),
          DayStat(date: DateTime(2026, 2, 3), score: 80, hoursSlept: 7.5, bedtimeHour: 23, snorePercent: 4, awakenings: 1),
        ];
        final best = SleepStatsData.bestDay(data)!;
        expect(best.score, 90);
        expect(best.date, DateTime(2026, 2, 2));
      });

      test('returns first when tied', () {
        final data = [
          DayStat(date: DateTime(2026, 2, 1), score: 85, hoursSlept: 7, bedtimeHour: 23, snorePercent: 5, awakenings: 1),
          DayStat(date: DateTime(2026, 2, 2), score: 85, hoursSlept: 8, bedtimeHour: 23, snorePercent: 3, awakenings: 0),
        ];
        final best = SleepStatsData.bestDay(data)!;
        expect(best.date, DateTime(2026, 2, 1));
      });
    });

    group('weekdayNameRu', () {
      test('returns correct short names', () {
        expect(SleepStatsData.weekdayNameRu(1), 'Пн');
        expect(SleepStatsData.weekdayNameRu(2), 'Вт');
        expect(SleepStatsData.weekdayNameRu(3), 'Ср');
        expect(SleepStatsData.weekdayNameRu(4), 'Чт');
        expect(SleepStatsData.weekdayNameRu(5), 'Пт');
        expect(SleepStatsData.weekdayNameRu(6), 'Сб');
        expect(SleepStatsData.weekdayNameRu(7), 'Вс');
      });
    });

    group('weekdayFullRu', () {
      test('returns correct full names', () {
        expect(SleepStatsData.weekdayFullRu(1), 'Понедельник');
        expect(SleepStatsData.weekdayFullRu(2), 'Вторник');
        expect(SleepStatsData.weekdayFullRu(3), 'Среда');
        expect(SleepStatsData.weekdayFullRu(4), 'Четверг');
        expect(SleepStatsData.weekdayFullRu(5), 'Пятница');
        expect(SleepStatsData.weekdayFullRu(6), 'Суббота');
        expect(SleepStatsData.weekdayFullRu(7), 'Воскресенье');
      });
    });

    group('fromModels', () {
      test('converts SleepSessionModel list to DayStat list', () {
        final models = [
          SleepSessionModel(
            id: '1',
            date: DateTime(2026, 2, 10),
            bedtime: DateTime(2026, 2, 9, 23, 0),
            wakeTime: DateTime(2026, 2, 10, 7, 0),
            score: 85,
            snorePercent: 8,
            hoursSlept: 8.0,
            bedtimeHour: 23.0,
            awakenings: 1,
            phases: [],
          ),
        ];

        final stats = SleepStatsData.fromModels(models);
        expect(stats.length, 1);
        expect(stats.first.score, 85);
        expect(stats.first.hoursSlept, 8.0);
        expect(stats.first.bedtimeHour, 23.0);
        expect(stats.first.snorePercent, 8);
        expect(stats.first.awakenings, 1);
      });

      test('returns empty list for empty models', () {
        expect(SleepStatsData.fromModels([]), isEmpty);
      });
    });
  });
}
