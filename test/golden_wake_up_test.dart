import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/core/theme/app_theme.dart';
import 'package:sleepwise/features/wake_up/wake_up_screen.dart';
import 'package:sleepwise/features/wake_up/widgets/stop_alarm_button.dart';
import 'package:sleepwise/features/wake_up/widgets/swipe_to_stop.dart';

void main() {
  const screenSize = Size(1170, 2532);
  const pixelRatio = 3.0;

  setUp(() {
    // Register mock handlers for audioplayers platform channels
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers'),
      (call) async => null,
    );
    // Global events channel — needs StreamHandler mock
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(
      const EventChannel('xyz.luan/audioplayers.global/events'),
      MockStreamHandler.inline(
        onListen: (args, sink) {},
        onCancel: (args) {},
      ),
    );
  });

  testWidgets('Wake up — early sunrise (night stage)', (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const WakeUpScreen(),
      ),
    );
    // Early — still night
    await tester.pump(const Duration(milliseconds: 500));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/wake_up_night.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Wake up — full sunrise (final warm state)', (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const WakeUpScreen(),
      ),
    );
    // Pump past the full 10s sunrise + greeting fade-in
    for (int i = 0; i < 25; i++) {
      await tester.pump(const Duration(milliseconds: 500));
    }

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/wake_up_sunrise.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Wake up — swipe-to-stop variant', (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const WakeUpScreen(useSwipeToStop: true),
      ),
    );
    // Full sunrise
    for (int i = 0; i < 25; i++) {
      await tester.pump(const Duration(milliseconds: 500));
    }

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/wake_up_swipe.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Stop alarm button — standalone golden', (tester) async {
    tester.view.physicalSize = const Size(900, 900);
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: Scaffold(
          backgroundColor: const Color(0xFFFF8C42),
          body: Center(
            child: StopAlarmButton(onPressed: () {}),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/stop_alarm_button.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Swipe to stop — standalone golden', (tester) async {
    tester.view.physicalSize = const Size(1170, 600);
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: Scaffold(
          backgroundColor: const Color(0xFFFF8C42),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SwipeToStop(onStopped: () {}),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/swipe_to_stop.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
