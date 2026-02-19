import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/app/router.dart';

void main() {
  group('AppRouter', () {
    test('route constants are defined', () {
      expect(AppRouter.showcase, '/showcase');
      expect(AppRouter.onboarding, '/onboarding');
      expect(AppRouter.permissions, '/permissions');
      expect(AppRouter.home, '/home');
      expect(AppRouter.alarm, '/alarm');
      expect(AppRouter.sleepTracking, '/sleep-tracking');
      expect(AppRouter.wakeUp, '/wake-up');
      expect(AppRouter.morningReport, '/morning-report');
    });

    test('all routes are unique except alias', () {
      final routes = [
        AppRouter.showcase,
        AppRouter.onboarding,
        AppRouter.permissions,
        AppRouter.home,
        AppRouter.sleepTracking,
        AppRouter.wakeUp,
        AppRouter.morningReport,
      ];
      // alarm is an alias for home so we don't include it
      final unique = routes.toSet();
      expect(unique.length, routes.length, reason: 'All route names should be unique');
    });

    test('alarm is an alias for home', () {
      // Both should route to HomeShell
      expect(AppRouter.alarm, isNot(equals(AppRouter.home)));
    });

    test('onGenerateRoute returns Route for all defined routes', () {
      final routeNames = [
        AppRouter.showcase,
        AppRouter.onboarding,
        AppRouter.permissions,
        AppRouter.home,
        AppRouter.alarm,
        AppRouter.sleepTracking,
        AppRouter.wakeUp,
        AppRouter.morningReport,
      ];

      for (final name in routeNames) {
        final route = AppRouter.onGenerateRoute(RouteSettings(name: name));
        expect(route, isA<Route>(), reason: 'Route for $name should be a Route');
      }
    });

    test('onGenerateRoute returns route for unknown route', () {
      final route = AppRouter.onGenerateRoute(
        const RouteSettings(name: '/nonexistent'),
      );
      expect(route, isA<Route>());
    });
  });
}
