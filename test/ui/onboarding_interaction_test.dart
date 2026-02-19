import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/features/onboarding/onboarding_screen.dart';
import 'package:sleepwise/features/onboarding/widgets/page_indicator.dart';

import '../helpers/localized_app.dart';

void main() {
  const screenSize = Size(1170, 2532);
  const pixelRatio = 3.0;

  void setScreen(WidgetTester tester) {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;
  }

  void resetScreen(WidgetTester tester) {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  }

  group('Onboarding Screen — Navigation', () {
    testWidgets('page 1 renders with correct elements', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const OnboardingScreen()));
      await tester.pump(const Duration(milliseconds: 500));

      // Skip button visible (text-based, Russian locale)
      expect(find.text('Пропустить'), findsOneWidget);

      // Page indicator present
      expect(find.byType(PageIndicator), findsOneWidget);

      // Next arrow button visible
      expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);

      // No overflow errors
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });

    testWidgets('swipe through all 4 pages without errors', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const OnboardingScreen()));
      await tester.pump(const Duration(milliseconds: 500));

      // Page 1 → 2
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pump(const Duration(milliseconds: 400));
      expect(tester.takeException(), isNull);

      // Page 2 → 3
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pump(const Duration(milliseconds: 400));
      expect(tester.takeException(), isNull);

      // Page 3 → 4
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pump(const Duration(milliseconds: 400));
      expect(tester.takeException(), isNull);

      // On last page, arrow button should be gone
      expect(find.byIcon(Icons.arrow_forward_rounded), findsNothing);

      resetScreen(tester);
    });

    testWidgets('next button advances pages', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const OnboardingScreen()));
      await tester.pump(const Duration(milliseconds: 500));

      // Tap next button 3 times
      for (var i = 0; i < 3; i++) {
        final nextBtn = find.byIcon(Icons.arrow_forward_rounded);
        if (nextBtn.evaluate().isNotEmpty) {
          await tester.tap(nextBtn);
          await tester.pump(const Duration(milliseconds: 400));
        }
      }

      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });

    testWidgets('skip button exists on first pages', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const OnboardingScreen()));
      await tester.pump(const Duration(milliseconds: 500));

      // Skip visible on page 1
      expect(find.text('Пропустить'), findsOneWidget);

      resetScreen(tester);
    });

    testWidgets('no text overflow on any page', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const OnboardingScreen()));

      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        // Check for overflow errors
        expect(tester.takeException(), isNull);

        if (i < 3) {
          await tester.drag(find.byType(PageView), const Offset(-400, 0));
        }
      }

      resetScreen(tester);
    });
  });
}
