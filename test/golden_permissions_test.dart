import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/core/theme/app_theme.dart';
import 'package:sleepwise/features/onboarding/permissions_screen.dart';
import 'package:sleepwise/widgets/gradient_background.dart';

void main() {
  /// Wraps a page body in Scaffold + GradientBackground + SafeArea,
  /// matching the real PermissionsScreen chrome.
  Widget wrapPage(Widget page) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: Scaffold(
        body: GradientBackground(
          child: SafeArea(child: page),
        ),
      ),
    );
  }

  testWidgets('Permission — microphone screen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;

    await tester.pumpWidget(
      wrapPage(
        MicrophonePermPage(denied: false, onAllow: () {}),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/permission_microphone.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Permission — notification screen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;

    await tester.pumpWidget(
      wrapPage(
        NotificationPermPage(denied: false, onAllow: () {}, onSkip: () {}),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/permission_notification.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
