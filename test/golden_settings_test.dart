import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/features/settings/settings_screen.dart';

import 'helpers/localized_app.dart';

void main() {
  const screenSize = Size(1170, 2532);
  const pixelRatio = 3.0;

  testWidgets('Settings — top (alarm + tracking groups)', (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      localizedApp(home: const SettingsScreen()),
    );
    await tester.pump(const Duration(milliseconds: 500));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/settings_top.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Settings — scrolled to middle (integrations + appearance)',
      (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      localizedApp(home: const SettingsScreen()),
    );
    await tester.pump(const Duration(milliseconds: 500));

    await tester.drag(
        find.byType(SingleChildScrollView), const Offset(0, -500));
    await tester.pump(const Duration(milliseconds: 300));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/settings_middle.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Settings — scrolled to bottom (pro + about)',
      (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      localizedApp(home: const SettingsScreen()),
    );
    await tester.pump(const Duration(milliseconds: 500));

    // Scroll far enough to see Pro banner and About
    await tester.drag(
        find.byType(SingleChildScrollView), const Offset(0, -1000));
    await tester.pump(const Duration(milliseconds: 300));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/settings_bottom.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
