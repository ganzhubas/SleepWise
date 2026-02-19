import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/features/settings/settings_screen.dart';
import 'package:sleepwise/features/settings/widgets/settings_group.dart';
import 'package:sleepwise/features/settings/widgets/settings_tile.dart';
import 'package:sleepwise/features/settings/widgets/segment_option.dart';
import 'package:sleepwise/features/settings/widgets/pro_banner.dart';

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

  group('Settings Screen — Layout', () {
    testWidgets('renders all settings groups', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const SettingsScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 500));

      // Should have multiple SettingsGroup widgets (Alarm, Tracking, Integrations, Appearance, Account, About)
      expect(find.byType(SettingsGroup), findsWidgets);
      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });

    testWidgets('renders settings tiles', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const SettingsScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(SettingsTile), findsWidgets);
      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });

    testWidgets('renders segment options', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const SettingsScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 500));

      // Sensitivity, Theme, Language segments
      expect(find.byType(SegmentOption<String>), findsWidgets);
      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });

    testWidgets('renders PRO banner', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const SettingsScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 500));

      // Scroll to find ProBanner
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(ProBanner), findsOneWidget);
      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });

    testWidgets('shows version 1.0.0', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const SettingsScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 500));

      // Scroll to bottom
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -600),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('1.0.0'), findsOneWidget);
      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });
  });

  group('Settings Screen — Alarm Group', () {
    testWidgets('volume slider is present and draggable', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const SettingsScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(Slider), findsOneWidget);

      // Drag slider
      await tester.drag(find.byType(Slider), const Offset(30, 0));
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });

    testWidgets('snooze toggle is present', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const SettingsScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 500));

      // Switch.adaptive for snooze
      expect(find.byType(Switch), findsWidgets);
      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });

    testWidgets('snooze toggle is tappable', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const SettingsScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 500));

      // Tap the first Switch widget (snooze)
      final switches = find.byType(Switch);
      if (switches.evaluate().isNotEmpty) {
        await tester.tap(switches.first);
        await tester.pump(const Duration(milliseconds: 300));
      }
      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });
  });

  group('Settings Screen — Scrolling', () {
    testWidgets('settings is scrollable', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const SettingsScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 500));

      // Scroll down
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -400),
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // Scroll back up
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, 400),
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });
  });

  group('Settings Screen — No Overflow', () {
    testWidgets('no overflow on settings screen', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const SettingsScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 1000));

      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });

    testWidgets('no overflow after scrolling', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const SettingsScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 500));

      // Scroll to bottom
      for (int i = 0; i < 5; i++) {
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -200),
        );
        await tester.pump(const Duration(milliseconds: 200));
      }
      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });
  });
}
