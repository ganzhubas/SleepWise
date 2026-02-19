// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class LEn extends L {
  LEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SleepWise';

  @override
  String get skip => 'Skip';

  @override
  String get cancel => 'Cancel';

  @override
  String get done => 'Done';

  @override
  String get allow => 'Allow';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get notNow => 'Not now';

  @override
  String get later => 'Later';

  @override
  String get understood => 'Got it';

  @override
  String get start => 'Start';

  @override
  String get onboardingTitle1 => 'Wake up refreshed';

  @override
  String get onboardingSubtitle1 =>
      'SleepWise analyzes your sleep\nand wakes you at the perfect moment';

  @override
  String get onboardingTitle2 => 'Just place your\nphone nearby';

  @override
  String get onboardingSubtitle2 =>
      'The microphone detects sleep phases\nby movement sounds';

  @override
  String get onboardingTitle3 => 'Your sleep in detail';

  @override
  String get onboardingSubtitle3 => 'Clear charts and a score\nevery morning';

  @override
  String get onboardingTitle4 => 'All set!';

  @override
  String get onboardingSubtitle4 => 'Set your alarm and\nsleep peacefully';

  @override
  String get onboardingDisclaimer =>
      'The app will request access\nto microphone and notifications';

  @override
  String get permMicTitle => 'Microphone Access';

  @override
  String get permMicAllowed =>
      'SleepWise only listens for movement sounds\nto analyze sleep phases. Audio is not recorded.';

  @override
  String get permMicDenied =>
      'Sleep analysis requires the microphone.\nYou can grant access in Settings.';

  @override
  String get permPrivacy => 'Learn more about privacy';

  @override
  String get permNotifTitle => 'Notifications';

  @override
  String get permNotifAllowed =>
      'So the alarm works reliably,\neven when the app is in the background';

  @override
  String get permNotifDenied =>
      'The alarm may not work without notifications.\nYou can enable them in Settings.';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingDay => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get greetingNight => 'Good night';

  @override
  String alarmInMinutes(int minutes) {
    return 'Alarm in $minutes min';
  }

  @override
  String alarmInHours(int hours) {
    return 'Alarm in $hours h';
  }

  @override
  String alarmInHoursMinutes(int hours, int minutes) {
    return 'Alarm in $hours h $minutes min';
  }

  @override
  String alarmBetween(String start, String end) {
    return 'Alarm between $start and $end';
  }

  @override
  String wakeWindowLabel(int minutes) {
    return 'Wake window: $minutes min';
  }

  @override
  String get alarmTimeTitle => 'Alarm time';

  @override
  String get activitySilence => 'SILENCE';

  @override
  String get activityLightSleep => 'LIGHT SLEEP';

  @override
  String get activityMedium => 'ACTIVITY';

  @override
  String get activityAwake => 'AWAKE';

  @override
  String get activitySnoring => 'SNORING';

  @override
  String get sleepTracking => 'Sleep tracking';

  @override
  String alarmRange(String start, String end) {
    return 'Alarm: $start – $end';
  }

  @override
  String battery(int percent) {
    return 'Battery: $percent%';
  }

  @override
  String get stopTrackingTitle => 'Stop tracking?';

  @override
  String get stopTrackingSubtitle => 'Sleep data will be saved';

  @override
  String get stopButton => 'Stop';

  @override
  String get continueButton => 'Continue';

  @override
  String get goodMorning => 'Good morning!';

  @override
  String get snoozeButton => 'Snooze 5 min';

  @override
  String snoozeRemaining(int remaining, int total) {
    return '$remaining of $total left';
  }

  @override
  String get noSnoozeLeft => 'No snoozes left';

  @override
  String sleepDurationFormat(int hours, int minutes) {
    return '${hours}h ${minutes}min';
  }

  @override
  String get sleepTimeLabel => 'Sleep time';

  @override
  String get fellAsleep => 'Fell asleep';

  @override
  String get wokeUp => 'Woke up';

  @override
  String get inBed => 'In bed';

  @override
  String get awakenings => 'Awakenings';

  @override
  String get hypnogram => 'Hypnogram';

  @override
  String get snore => 'Snoring';

  @override
  String get ofNight => 'of night';

  @override
  String get scoreExcellent => 'Excellent sleep';

  @override
  String get scoreGood => 'Good sleep';

  @override
  String get scoreAverage => 'Average sleep';

  @override
  String get scorePoor => 'Poor sleep';

  @override
  String get stageDeep => 'Deep';

  @override
  String get stageLight => 'Light';

  @override
  String get stageRem => 'REM';

  @override
  String get stageAwake => 'Awake';

  @override
  String get recommendationExcellent =>
      'Great night! You fell asleep quickly and slept steadily. Try going to bed at the same time every day for a consistent routine.';

  @override
  String get recommendationGood =>
      'Decent sleep, but there\'s room to improve. Try going to bed 30 minutes earlier and reducing screen time before sleep.';

  @override
  String get recommendationPoor =>
      'Sleep could have been better tonight. Pay attention to your daily routine, avoid caffeine after 4 PM, and create comfortable conditions.';

  @override
  String get statistics => 'Statistics';

  @override
  String get period7days => '7 days';

  @override
  String get period30days => '30 days';

  @override
  String get period3months => '3 mo';

  @override
  String get avgSleepTime => 'Avg sleep time';

  @override
  String get avgBedtime => 'Avg bedtime';

  @override
  String get bestDay => 'Best day';

  @override
  String snoreAvg(int percent) {
    return '$percent% average';
  }

  @override
  String get weekdayShortMon => 'Mon';

  @override
  String get weekdayShortTue => 'Tue';

  @override
  String get weekdayShortWed => 'Wed';

  @override
  String get weekdayShortThu => 'Thu';

  @override
  String get weekdayShortFri => 'Fri';

  @override
  String get weekdayShortSat => 'Sat';

  @override
  String get weekdayShortSun => 'Sun';

  @override
  String get weekdayMon => 'Monday';

  @override
  String get weekdayTue => 'Tuesday';

  @override
  String get weekdayWed => 'Wednesday';

  @override
  String get weekdayThu => 'Thursday';

  @override
  String get weekdayFri => 'Friday';

  @override
  String get weekdaySat => 'Saturday';

  @override
  String get weekdaySun => 'Sunday';

  @override
  String get settings => 'Settings';

  @override
  String get settingsAlarm => 'Alarm';

  @override
  String get settingsMelody => 'Alarm melody';

  @override
  String get settingsVolume => 'Volume';

  @override
  String get settingsWakeWindow => 'Wake window';

  @override
  String get settingsSnooze => 'Snooze';

  @override
  String get settingsSnoozeDesc => '5 min, max 3 times';

  @override
  String get settingsTracking => 'Tracking';

  @override
  String get settingsSensitivity => 'Sensitivity';

  @override
  String get settingsReminder => 'Reminder';

  @override
  String get settingsIntegrations => 'Integrations';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get themeAuto => 'Auto';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get langRu => 'Рус';

  @override
  String get langEn => 'Eng';

  @override
  String get settingsAccount => 'Account';

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get settingsAbout => 'About';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get rateApp => 'Rate the app';

  @override
  String get version => 'Version';

  @override
  String get sensitivityLow => 'Low';

  @override
  String get sensitivityMed => 'Med';

  @override
  String get sensitivityHigh => 'High';

  @override
  String get healthNotConnected => 'Not connected';

  @override
  String get healthConnected => 'Connected';

  @override
  String get healthNoPermission => 'No permissions';

  @override
  String get healthDenied => 'Access denied';

  @override
  String get healthUnavailable => 'Unavailable';

  @override
  String get healthConnecting => 'Connecting...';

  @override
  String get healthViaConnect => 'Via Health Connect';

  @override
  String get healthFailed => 'Connection failed';

  @override
  String get healthConnectNotFound => 'Health Connect not found';

  @override
  String healthPermSnackbar(String platform) {
    return 'Allow access to $platform in device settings';
  }

  @override
  String healthUnavailableTitle(String name) {
    return '$name unavailable';
  }

  @override
  String get healthConnectInstall =>
      'Install Health Connect from Google Play to sync sleep data.';

  @override
  String get healthAppleCheck =>
      'Make sure the Health app is available on your device.';

  @override
  String get samsungHealthTitle => 'Samsung Health';

  @override
  String get samsungHealthInstructions =>
      'On newer devices, Samsung Health syncs via Google Health Connect.\n\n1. Install Health Connect from Google Play\n2. Open Samsung Health → Settings → Health Connect\n3. Allow data sync\n4. Come back here and enable the toggle';

  @override
  String get sleepDataLabel => 'Sleep data';

  @override
  String get autoWrite => 'Auto-write';

  @override
  String get off => 'Off';

  @override
  String minutesShort(int m) {
    return '$m min';
  }

  @override
  String get melodyVibration => 'Vibration';

  @override
  String get paywallTitle => 'Unlock your\nsleep potential';

  @override
  String get paywallSubtitle => 'Everything for perfect sleep in one place';

  @override
  String get paywallFeature1 => 'Full sleep history without limits';

  @override
  String get paywallFeature2 => 'Advanced analytics and trends';

  @override
  String get paywallFeature3 => 'Schedule by day of the week';

  @override
  String get paywallFeature4 => 'Detailed snoring analysis';

  @override
  String get paywallFeature5 => 'Additional melodies';

  @override
  String get paywallFeature6 => 'Data export';

  @override
  String get paywallFeature7 => 'Ad-free';

  @override
  String get planMonthly => 'Monthly';

  @override
  String get planMonthlyPrice => '\$0.99/mo';

  @override
  String get planYearly => 'Yearly';

  @override
  String get planYearlyPrice => '\$5.99/yr';

  @override
  String get planYearlyBadge => '−45%';

  @override
  String get finePrintYearly => 'Then \$5.99/year. Cancel anytime.';

  @override
  String get finePrintMonthly => 'Then \$0.99/month. Cancel anytime.';

  @override
  String get tryFree => 'Try 7 days free';

  @override
  String get tryFreeBanner => 'Try for free';

  @override
  String get proBannerFeature1 => 'Detailed sleep analytics';

  @override
  String get proBannerFeature2 => 'AI-powered smart alarm';

  @override
  String get proBannerFeature3 => 'Unlimited history';

  @override
  String get proBannerFeature4 => 'Data export';

  @override
  String get proBannerFeature5 => 'Ad-free';

  @override
  String get batteryOptTitle => 'Battery Optimization';

  @override
  String batteryOptMessage(String brand) {
    return '$brand devices may kill apps running in the background.\n\nFor the alarm to work reliably, disable battery optimization for SleepWise in your device settings.\n\nLearn more: dontkillmyapp.com';
  }

  @override
  String get batteryManualInstructions =>
      'Open Settings → Battery → SleepWise → Unrestricted';

  @override
  String get notifAlarmChannel => 'Alarm';

  @override
  String get notifAlarmDesc => 'SleepWise alarm — safety net notification';

  @override
  String get notifReminderChannel => 'Reminders';

  @override
  String get notifReminderDesc => 'Bedtime reminder';

  @override
  String get notifAlarmTitle => 'Time to wake up!';

  @override
  String get notifAlarmBody => 'Your SleepWise alarm went off';

  @override
  String get notifReminderTitle => 'Time to get ready for bed';

  @override
  String get notifReminderBody => 'Set your alarm in SleepWise';

  @override
  String get notifSetAlarmAction => 'Set alarm';

  @override
  String get tabAlarm => 'Alarm';

  @override
  String get tabStatistics => 'Statistics';

  @override
  String get tabSettings => 'Settings';
}
