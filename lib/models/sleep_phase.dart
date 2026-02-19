enum SleepPhaseType {
  awake,
  light,
  deep,
  rem,
}

class SleepPhase {
  final SleepPhaseType type;
  final DateTime startTime;
  final DateTime endTime;

  SleepPhase({
    required this.type,
    required this.startTime,
    required this.endTime,
  });

  Duration get duration => endTime.difference(startTime);
}
