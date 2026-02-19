/// Single day of sleep statistics.
class DayStat {
  final DateTime date;
  final int score; // 0-100
  final double hoursSlept; // e.g. 7.4
  final double bedtimeHour; // e.g. 23.25 = 23:15
  final int snorePercent; // 0-100
  final int awakenings;

  const DayStat({
    required this.date,
    required this.score,
    required this.hoursSlept,
    required this.bedtimeHour,
    required this.snorePercent,
    required this.awakenings,
  });
}

/// 14 days of hardcoded test data.
class SleepStatsData {
  SleepStatsData._();

  static final List<DayStat> days = [
    // Week 1 (older) — Mon to Sun
    DayStat(date: DateTime(2026, 2, 2), score: 68, hoursSlept: 6.8, bedtimeHour: 23.75, snorePercent: 12, awakenings: 3),
    DayStat(date: DateTime(2026, 2, 3), score: 72, hoursSlept: 7.1, bedtimeHour: 23.50, snorePercent: 8, awakenings: 2),
    DayStat(date: DateTime(2026, 2, 4), score: 64, hoursSlept: 6.3, bedtimeHour: 0.25, snorePercent: 15, awakenings: 4),
    DayStat(date: DateTime(2026, 2, 5), score: 78, hoursSlept: 7.5, bedtimeHour: 23.25, snorePercent: 6, awakenings: 1),
    DayStat(date: DateTime(2026, 2, 6), score: 70, hoursSlept: 7.0, bedtimeHour: 23.50, snorePercent: 10, awakenings: 2),
    DayStat(date: DateTime(2026, 2, 7), score: 85, hoursSlept: 8.2, bedtimeHour: 23.00, snorePercent: 4, awakenings: 1),
    DayStat(date: DateTime(2026, 2, 8), score: 80, hoursSlept: 7.8, bedtimeHour: 23.25, snorePercent: 7, awakenings: 1),

    // Week 2 (current) — Mon to Sun
    DayStat(date: DateTime(2026, 2, 9), score: 74, hoursSlept: 7.2, bedtimeHour: 23.50, snorePercent: 9, awakenings: 2),
    DayStat(date: DateTime(2026, 2, 10), score: 82, hoursSlept: 7.6, bedtimeHour: 23.25, snorePercent: 5, awakenings: 1),
    DayStat(date: DateTime(2026, 2, 11), score: 45, hoursSlept: 5.2, bedtimeHour: 1.50, snorePercent: 18, awakenings: 5),
    DayStat(date: DateTime(2026, 2, 12), score: 88, hoursSlept: 8.0, bedtimeHour: 22.75, snorePercent: 3, awakenings: 0),
    DayStat(date: DateTime(2026, 2, 13), score: 76, hoursSlept: 7.3, bedtimeHour: 23.50, snorePercent: 8, awakenings: 2),
    DayStat(date: DateTime(2026, 2, 14), score: 91, hoursSlept: 8.4, bedtimeHour: 22.50, snorePercent: 2, awakenings: 0),
    DayStat(date: DateTime(2026, 2, 15), score: 79, hoursSlept: 7.4, bedtimeHour: 23.25, snorePercent: 7, awakenings: 1),
  ];

  /// Returns last [n] days from the dataset.
  static List<DayStat> lastDays(int n) {
    if (n >= days.length) return days;
    return days.sublist(days.length - n);
  }

  /// Average score for a list of days.
  static double averageScore(List<DayStat> data) {
    if (data.isEmpty) return 0;
    return data.map((d) => d.score).reduce((a, b) => a + b) / data.length;
  }

  /// Average hours slept.
  static double averageHours(List<DayStat> data) {
    if (data.isEmpty) return 0;
    return data.map((d) => d.hoursSlept).reduce((a, b) => a + b) / data.length;
  }

  /// Average bedtime hour.
  static double averageBedtime(List<DayStat> data) {
    if (data.isEmpty) return 0;
    // Normalize: hours > 12 stay, hours < 12 add 24 for averaging
    final normalized = data.map((d) => d.bedtimeHour < 12 ? d.bedtimeHour + 24 : d.bedtimeHour);
    final avg = normalized.reduce((a, b) => a + b) / data.length;
    return avg >= 24 ? avg - 24 : avg;
  }

  /// Average snore percent.
  static double averageSnore(List<DayStat> data) {
    if (data.isEmpty) return 0;
    return data.map((d) => d.snorePercent).reduce((a, b) => a + b) / data.length;
  }

  /// Best day (highest score).
  static DayStat? bestDay(List<DayStat> data) {
    if (data.isEmpty) return null;
    return data.reduce((a, b) => a.score >= b.score ? a : b);
  }

  /// Day name in Russian from weekday index.
  static String weekdayNameRu(int weekday) {
    const names = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return names[(weekday - 1) % 7];
  }

  /// Full day name in Russian.
  static String weekdayFullRu(int weekday) {
    const names = ['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'];
    return names[(weekday - 1) % 7];
  }
}
