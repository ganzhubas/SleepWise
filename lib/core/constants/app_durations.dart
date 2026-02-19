class AppDurations {
  AppDurations._();

  // Animation durations (milliseconds)
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);

  // Page transition
  static const Duration pageTransition = Duration(milliseconds: 350);

  // Alarm snooze
  static const Duration snoozeDuration = Duration(minutes: 5);

  // Sleep tracking
  static const Duration trackingInterval = Duration(seconds: 30);
}
