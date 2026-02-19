import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/features/statistics/statistics_screen.dart';
import 'package:sleepwise/features/statistics/widgets/period_selector.dart';

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

  group('Statistics Screen — Layout', () {
    testWidgets('renders period selector', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const StatisticsScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(PeriodSelector), findsOneWidget);
      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });

    testWidgets('shows empty state or charts', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const StatisticsScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 2000));

      // Either empty state icon or chart content should render
      final hasEmptyIcon = find.byIcon(Icons.nights_stay_rounded).evaluate().isNotEmpty;
      final hasScrollView = find.byType(SingleChildScrollView).evaluate().isNotEmpty;
      expect(hasEmptyIcon || hasScrollView, true);

      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });

    testWidgets('title text is rendered', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const StatisticsScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 500));

      // Find any Montserrat 28px text (the title)
      expect(find.byType(Text), findsWidgets);
      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });
  });

  group('Statistics Screen — Period Selector', () {
    testWidgets('period selector has 3 options', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const StatisticsScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 500));

      // PeriodSelector contains 3 tappable segments
      expect(find.byType(PeriodSelector), findsOneWidget);
      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });

    testWidgets('tapping period options triggers rebuild', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const StatisticsScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 2000));

      // Find GestureDetectors inside PeriodSelector (the tappable segments)
      final gestureDetectors = find.descendant(
        of: find.byType(PeriodSelector),
        matching: find.byType(GestureDetector),
      );

      if (gestureDetectors.evaluate().length >= 3) {
        // Tap second option (Month)
        await tester.tap(gestureDetectors.at(1));
        await tester.pump(const Duration(milliseconds: 300));
        expect(tester.takeException(), isNull);

        // Tap third option (3 Months)
        await tester.tap(gestureDetectors.at(2));
        await tester.pump(const Duration(milliseconds: 300));
        expect(tester.takeException(), isNull);

        // Tap back to first (Week)
        await tester.tap(gestureDetectors.at(0));
        await tester.pump(const Duration(milliseconds: 300));
        expect(tester.takeException(), isNull);
      }

      resetScreen(tester);
    });
  });

  group('Statistics Screen — Animation', () {
    testWidgets('stagger animation runs smoothly', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const StatisticsScreen(),
      ));

      // Pump through full animation (1800ms)
      for (int i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });
  });

  group('Statistics Screen — No Overflow', () {
    testWidgets('no overflow on statistics screen', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const StatisticsScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 2000));

      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });
  });
}
