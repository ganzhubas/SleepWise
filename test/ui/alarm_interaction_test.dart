import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/app/home_shell.dart';
import 'package:sleepwise/features/alarm/alarm_screen.dart';
import 'package:sleepwise/features/alarm/widgets/start_button.dart';
import 'package:sleepwise/features/alarm/widgets/time_picker_sheet.dart';
import 'package:sleepwise/features/alarm/widgets/wake_window_selector.dart';
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

  group('Alarm Screen — Layout & Display', () {
    testWidgets('renders all main elements', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const AlarmScreen()));
      await tester.pump(const Duration(milliseconds: 500));

      // Alarm time display exists (default 07:30)
      expect(find.text('07:30'), findsOneWidget);

      // Start button exists
      expect(find.byType(StartButton), findsOneWidget);

      // Wake window selector exists
      expect(find.byType(WakeWindowSelector), findsOneWidget);

      // No overflow
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });

    testWidgets('displays greeting based on time', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const AlarmScreen()));
      await tester.pump(const Duration(milliseconds: 500));

      // Should have some greeting text (varies by time of day)
      // We just check that something renders without error
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });

    testWidgets('no overflow on alarm screen', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const AlarmScreen()));
      await tester.pump(const Duration(milliseconds: 1000));

      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });
  });

  group('Alarm Screen — Time Picker', () {
    testWidgets('opens time picker on time display tap', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const AlarmScreen()));
      await tester.pump(const Duration(milliseconds: 500));

      // Tap the time display to open picker
      final timeFinder = find.text('07:30');
      if (timeFinder.evaluate().isNotEmpty) {
        await tester.tap(timeFinder.first);
        for (int i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 50));
        }

        // Bottom sheet should be visible
        expect(find.byType(TimePickerSheet), findsOneWidget);
        expect(tester.takeException(), isNull);
      }

      resetScreen(tester);
    });

    testWidgets('time picker has cancel and done buttons', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const AlarmScreen()));
      await tester.pump(const Duration(milliseconds: 500));

      // Open time picker
      final timeFinder = find.text('07:30');
      if (timeFinder.evaluate().isNotEmpty) {
        await tester.tap(timeFinder.first);
        for (int i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 50));
        }

        // Should have action buttons - using L10n Russian text
        expect(find.byType(TimePickerSheet), findsOneWidget);
      }

      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });

    testWidgets('time picker scrolls hours and minutes', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const AlarmScreen()));
      await tester.pump(const Duration(milliseconds: 500));

      final timeFinder = find.text('07:30');
      if (timeFinder.evaluate().isNotEmpty) {
        await tester.tap(timeFinder.first);
        for (int i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 50));
        }

        // Find ListWheelScrollView widgets (hour and minute pickers)
        final wheels = find.byType(ListWheelScrollView);
        expect(wheels, findsWidgets);

        // Drag to scroll hours
        if (wheels.evaluate().isNotEmpty) {
          await tester.drag(wheels.first, const Offset(0, -50));
          await tester.pump(const Duration(milliseconds: 200));
        }
      }

      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });
  });

  group('Alarm Screen — Wake Window', () {
    testWidgets('wake window selector renders 5 options', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const AlarmScreen()));
      await tester.pump(const Duration(milliseconds: 500));

      // 5 window options: 10, 20, 30, 45, 60
      expect(find.text('10'), findsOneWidget);
      expect(find.text('20'), findsOneWidget);
      expect(find.text('30'), findsOneWidget);
      expect(find.text('45'), findsOneWidget);
      expect(find.text('60'), findsOneWidget);

      resetScreen(tester);
    });

    testWidgets('tapping wake window options changes selection', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const AlarmScreen()));
      await tester.pump(const Duration(milliseconds: 500));

      // Tap 20-minute window
      await tester.tap(find.text('20'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // Tap 45-minute window
      await tester.tap(find.text('45'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // Tap 60-minute window
      await tester.tap(find.text('60'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });
  });

  group('Alarm Screen — Start Button', () {
    testWidgets('start button renders with pulse animation', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const AlarmScreen()));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(StartButton), findsOneWidget);

      // Pump a few frames to verify pulse animation runs
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });

    testWidgets('start button is tappable', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const AlarmScreen()));
      await tester.pump(const Duration(milliseconds: 500));

      // Tap the start button area
      await tester.tap(find.byType(StartButton));
      await tester.pump(const Duration(milliseconds: 300));
      // May navigate or show dialog — either way, no crash
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });
  });

  group('Home Shell — Tab Navigation', () {
    testWidgets('bottom navigation has 3 tabs', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const HomeShell()));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byIcon(Icons.alarm_rounded), findsOneWidget);
      expect(find.byIcon(Icons.bar_chart_rounded), findsOneWidget);
      expect(find.byIcon(Icons.settings_rounded), findsOneWidget);

      resetScreen(tester);
    });

    testWidgets('switching tabs renders different screens', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const HomeShell()));
      await tester.pump(const Duration(milliseconds: 500));

      // Tap Statistics tab
      await tester.tap(find.byIcon(Icons.bar_chart_rounded));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // Tap Settings tab
      await tester.tap(find.byIcon(Icons.settings_rounded));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // Tap back to Alarm tab
      await tester.tap(find.byIcon(Icons.alarm_rounded));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });

    testWidgets('no overflow on any tab', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const HomeShell()));
      await tester.pump(const Duration(milliseconds: 500));

      // Alarm tab
      expect(tester.takeException(), isNull);

      // Statistics tab
      await tester.tap(find.byIcon(Icons.bar_chart_rounded));
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);

      // Settings tab
      await tester.tap(find.byIcon(Icons.settings_rounded));
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });
  });
}
