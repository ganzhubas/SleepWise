import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/features/paywall/paywall_screen.dart';

import 'helpers/localized_app.dart';

void main() {
  const screenSize = Size(1170, 2532);
  const pixelRatio = 3.0;

  testWidgets('Paywall — top (badge + features)', (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      localizedApp(home: const PaywallScreen()),
    );
    await tester.pump(const Duration(milliseconds: 1800));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/paywall_top.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Paywall — scrolled to plans + CTA', (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      localizedApp(home: const PaywallScreen()),
    );
    await tester.pump(const Duration(milliseconds: 1800));

    await tester.drag(
        find.byType(SingleChildScrollView), const Offset(0, -350));
    await tester.pump(const Duration(milliseconds: 300));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/paywall_bottom.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
