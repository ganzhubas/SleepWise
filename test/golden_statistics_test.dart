import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/features/statistics/statistics_screen.dart';

import 'helpers/localized_app.dart';

void main() {
  const screenSize = Size(1170, 2532);
  const pixelRatio = 3.0;

  testWidgets('Statistics — top (score + bar chart)', (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      localizedApp(home: const StatisticsScreen()),
    );
    // Let stagger animations finish
    await tester.pump(const Duration(milliseconds: 2000));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/statistics_top.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Statistics — scrolled to charts', (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      localizedApp(home: const StatisticsScreen()),
    );
    await tester.pump(const Duration(milliseconds: 2000));

    // Scroll down to duration + bedtime charts
    await tester.drag(
        find.byType(SingleChildScrollView), const Offset(0, -450));
    await tester.pump(const Duration(milliseconds: 300));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/statistics_charts.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Statistics — fully animated state', (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      localizedApp(home: const StatisticsScreen()),
    );
    // All animations complete
    await tester.pump(const Duration(milliseconds: 2500));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/statistics_full.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
