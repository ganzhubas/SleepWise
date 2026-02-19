import 'sleep_phase.dart';

class SleepSession {
  final DateTime bedtime;
  final DateTime wakeTime;
  final List<SleepPhase> phases;
  final int qualityRating;
  final String? notes;

  SleepSession({
    required this.bedtime,
    required this.wakeTime,
    this.phases = const [],
    this.qualityRating = 0,
    this.notes,
  });

  Duration get duration => wakeTime.difference(bedtime);
}
