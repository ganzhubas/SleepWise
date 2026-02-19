import 'package:flutter/material.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/onboarding/permissions_screen.dart';
import '../features/sleep_tracking/sleep_tracking_screen.dart';
import '../features/wake_up/wake_up_screen.dart';
import '../features/morning_report/morning_report_screen.dart';
import '../features/showcase/widget_showcase_screen.dart';
import 'home_shell.dart';

class AppRouter {
  static const String showcase = '/showcase';
  static const String onboarding = '/onboarding';
  static const String permissions = '/permissions';
  static const String home = '/home';
  static const String alarm = '/alarm'; // alias for home
  static const String sleepTracking = '/sleep-tracking';
  static const String wakeUp = '/wake-up';
  static const String morningReport = '/morning-report';

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case showcase:
        return MaterialPageRoute(builder: (_) => const WidgetShowcaseScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case permissions:
        return MaterialPageRoute(builder: (_) => const PermissionsScreen());
      case home:
      case alarm:
        return MaterialPageRoute(builder: (_) => const HomeShell());
      case sleepTracking:
        return MaterialPageRoute(builder: (_) => const SleepTrackingScreen());
      case wakeUp:
        return MaterialPageRoute(builder: (_) => const WakeUpScreen());
      case morningReport:
        return MaterialPageRoute(builder: (_) => const MorningReportScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeShell());
    }
  }
}
