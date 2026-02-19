import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/features/morning_report/morning_report_screen.dart';
import 'package:sleepwise/features/morning_report/widgets/hypnogram_chart.dart';
import 'package:sleepwise/features/morning_report/widgets/metric_card.dart';
import 'package:sleepwise/features/morning_report/widgets/sleep_card.dart';
import 'package:sleepwise/features/morning_report/widgets/sleep_score_circle.dart';
import 'package:sleepwise/features/morning_report/widgets/snore_card.dart';

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

  group('Morning Report — Layout & Display', () {
    testWidgets('renders all main sections', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const MorningReportScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 2500));

      // Score circle
      expect(find.byType(SleepScoreCircle), findsOneWidget);

      // Metric cards (4: fell asleep, woke up, in bed, awakenings)
      expect(find.byType(MetricCard), findsNWidgets(4));

      // Hypnogram
      expect(find.byType(HypnogramChart), findsOneWidget);

      // Snore card
      expect(find.byType(SnoreCard), findsOneWidget);

      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });

    testWidgets('score circle shows test fallback value 82', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const MorningReportScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 2500));

      // Default test score is 82
      expect(find.text('82'), findsOneWidget);
      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });

    testWidgets('done button is present', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const MorningReportScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 2500));

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });

    testWidgets('sleep cards render without error', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const MorningReportScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 2500));

      expect(find.byType(SleepCard), findsWidgets);
      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });
  });

  group('Morning Report — Stagger Animation', () {
    testWidgets('stagger animation runs without error', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const MorningReportScreen(),
      ));

      // Pump through stagger animation (2000ms total)
      for (int i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 300));
      }
      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });

    testWidgets('items become visible after animation', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const MorningReportScreen(),
      ));

      // After full animation
      await tester.pump(const Duration(milliseconds: 2500));

      // All elements should be rendered
      expect(find.byType(SleepScoreCircle), findsOneWidget);
      expect(find.byType(MetricCard), findsNWidgets(4));
      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });
  });

  group('Morning Report — Scrolling & Interaction', () {
    testWidgets('content is scrollable', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const MorningReportScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 2500));

      // Scroll down
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -200),
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });

    testWidgets('done button is tappable', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const MorningReportScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 2500));

      await tester.tap(find.byType(ElevatedButton));
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });

    testWidgets('metric cards are tappable', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const MorningReportScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 2500));

      // Tap first metric card
      final metrics = find.byType(MetricCard);
      if (metrics.evaluate().isNotEmpty) {
        await tester.tap(metrics.first);
        await tester.pump(const Duration(milliseconds: 200));
      }
      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });
  });

  group('Morning Report — Recommendation', () {
    testWidgets('recommendation icon is present', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const MorningReportScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 2500));

      expect(find.byIcon(Icons.lightbulb_outline_rounded), findsOneWidget);
      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });
  });

  group('Morning Report — No Overflow', () {
    testWidgets('no overflow on full report', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const MorningReportScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 2500));

      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });
  });
}
