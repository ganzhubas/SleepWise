import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/features/morning_report/morning_report_screen.dart';

import 'helpers/localized_app.dart';

void main() {
  const screenSize = Size(1170, 2532);
  const pixelRatio = 3.0;

  testWidgets('Morning report — hero + hypnogram (top)', (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      localizedApp(home: const MorningReportScreen()),
    );
    // Let stagger animations advance to ~80%
    await tester.pump(const Duration(milliseconds: 1600));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/morning_report_top.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Morning report — scrolled to bottom', (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      localizedApp(home: const MorningReportScreen()),
    );
    // Let all animations complete
    await tester.pump(const Duration(milliseconds: 2200));

    // Scroll down to reveal snore card, recommendation, and button
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
    await tester.pump(const Duration(milliseconds: 300));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/morning_report_bottom.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Morning report — fully animated state', (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      localizedApp(home: const MorningReportScreen()),
    );
    // All animations completed (stagger 2s + score circle 1.5s)
    await tester.pump(const Duration(milliseconds: 3500));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/morning_report_full.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
