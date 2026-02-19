import 'sleep_phase.dart';
import 'sleep_sample.dart';

class SleepSession {
  final DateTime bedtime;
  final DateTime wakeTime;
  final List<SleepPhase> phases;
  final List<SleepSample> samples;
  final int qualityRating;
  final String? notes;

  /// Overall sleep score 0–100.
  final int score;

  /// Percentage of time spent snoring (0–100).
  final int snorePercentage;

  SleepSession({
    required this.bedtime,
    required this.wakeTime,
    this.phases = const [],
    this.samples = const [],
    this.qualityRating = 0,
    this.score = 0,
    this.snorePercentage = 0,
    this.notes,
  });

  Duration get duration => wakeTime.difference(bedtime);

  double get hoursSlept => duration.inMinutes / 60.0;

  /// Percentage of time in deep sleep.
  double get deepSleepPercent => _phasePercent(SleepPhaseType.deep);

  /// Percentage of time in REM.
  double get remPercent => _phasePercent(SleepPhaseType.rem);

  double _phasePercent(SleepPhaseType type) {
    if (phases.isEmpty) return 0;
    final total = duration.inMinutes;
    if (total == 0) return 0;
    final phaseMinutes = phases
        .where((p) => p.type == type)
        .fold<int>(0, (sum, p) => sum + p.duration.inMinutes);
    return (phaseMinutes / total) * 100;
  }
}
