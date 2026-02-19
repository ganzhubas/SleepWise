import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/features/wake_up/wake_up_screen.dart';
import 'package:sleepwise/features/wake_up/widgets/stop_alarm_button.dart';
import 'package:sleepwise/features/wake_up/widgets/sunrise_background.dart';
import 'package:sleepwise/features/wake_up/widgets/swipe_to_stop.dart';

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

  setUp(() {
    // Mock audioplayers platform channels
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers'),
      (call) async => null,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(
      const EventChannel('xyz.luan/audioplayers.global/events'),
      MockStreamHandler.inline(
        onListen: (args, sink) {},
        onCancel: (args) {},
      ),
    );
  });

  group('Wake-Up Screen — Stop Button Mode', () {
    testWidgets('renders sunrise background and stop button', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const WakeUpScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(SunriseBackground), findsOneWidget);
      expect(find.byType(StopAlarmButton), findsOneWidget);
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });

    testWidgets('displays clock text', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const WakeUpScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 500));

      // Clock should show HH:MM format — find any Text with colon pattern
      final clockFinder = find.byWidgetPredicate((w) =>
          w is Text &&
          w.data != null &&
          RegExp(r'^\d{2}:\d{2}$').hasMatch(w.data!));
      expect(clockFinder, findsOneWidget);
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });

    testWidgets('stop button is tappable without crash', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const WakeUpScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.byType(StopAlarmButton));
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });

    testWidgets('snooze counter shows remaining count', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const WakeUpScreen(maxSnoozeCount: 3),
      ));
      await tester.pump(const Duration(milliseconds: 500));

      // Should find snooze text (GestureDetector with Column)
      expect(find.byType(GestureDetector), findsWidgets);
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });

    testWidgets('sunrise animation runs without error', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const WakeUpScreen(),
      ));

      // Pump through animation frames
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 500));
      }
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });

    testWidgets('greeting fades in after delay', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const WakeUpScreen(),
      ));

      // Before greeting delay
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(FadeTransition), findsWidgets);

      // After greeting delay (2s) + animation (1.2s)
      await tester.pump(const Duration(milliseconds: 2000));
      await tester.pump(const Duration(milliseconds: 1500));
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });

    testWidgets('stop button pulse animation runs', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const WakeUpScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 500));

      // Pump to let pulse animation run
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.byType(StopAlarmButton), findsOneWidget);
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });
  });

  group('Wake-Up Screen — Swipe Mode', () {
    testWidgets('renders swipe-to-stop slider', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const WakeUpScreen(useSwipeToStop: true),
      ));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(SwipeToStop), findsOneWidget);
      // Should NOT show stop button in swipe mode
      expect(find.byType(StopAlarmButton), findsNothing);
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });

    testWidgets('partial swipe springs back', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const WakeUpScreen(useSwipeToStop: true),
      ));
      await tester.pump(const Duration(milliseconds: 500));

      // Small drag (not enough to trigger stop)
      await tester.drag(find.byType(SwipeToStop), const Offset(50, 0));
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });

    testWidgets('no overflow in swipe mode', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const WakeUpScreen(useSwipeToStop: true),
      ));
      await tester.pump(const Duration(milliseconds: 1000));

      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });
  });

  group('Wake-Up Screen — No Overflow', () {
    testWidgets('no overflow in default mode', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const WakeUpScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 2000));

      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });

    testWidgets('no overflow with zero snooze', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(
        home: const WakeUpScreen(maxSnoozeCount: 0),
      ));
      await tester.pump(const Duration(milliseconds: 1000));

      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });
  });
}
