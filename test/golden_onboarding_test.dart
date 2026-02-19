import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/features/onboarding/onboarding_screen.dart';

import 'helpers/localized_app.dart';

void main() {
  Widget buildApp() {
    return localizedApp(
      home: const OnboardingScreen(),
      routes: {
        '/alarm': (_) => const Scaffold(body: Center(child: Text('Alarm'))),
      },
    );
  }

  // Use pump() instead of pumpAndSettle() — animations repeat forever
  Future<void> swipePage(WidgetTester tester) async {
    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('Onboarding page 1 — moon', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;

    await tester.pumpWidget(buildApp());
    await tester.pump(const Duration(milliseconds: 500));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/onboarding_page1.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Onboarding page 2 — phone', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;

    await tester.pumpWidget(buildApp());
    await tester.pump(const Duration(milliseconds: 500));

    await swipePage(tester);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/onboarding_page2.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Onboarding page 3 — chart', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;

    await tester.pumpWidget(buildApp());
    await tester.pump(const Duration(milliseconds: 500));

    await swipePage(tester);
    await swipePage(tester);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/onboarding_page3.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Onboarding page 4 — start', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;

    await tester.pumpWidget(buildApp());
    await tester.pump(const Duration(milliseconds: 500));

    for (int i = 0; i < 3; i++) {
      await swipePage(tester);
    }

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/onboarding_page4.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
