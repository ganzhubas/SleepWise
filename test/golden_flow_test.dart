import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/features/onboarding/onboarding_screen.dart';
import 'package:sleepwise/features/alarm/alarm_screen.dart';
import 'package:sleepwise/features/sleep_tracking/sleep_tracking_screen.dart';
import 'package:sleepwise/features/wake_up/wake_up_screen.dart';
import 'package:sleepwise/features/morning_report/morning_report_screen.dart';
import 'package:sleepwise/features/statistics/statistics_screen.dart';

import 'helpers/localized_app.dart';

void main() {
  const screenSize = Size(1170, 2532);
  const pixelRatio = 3.0;

  setUp(() {
    // Mock audioplayers platform channels for WakeUpScreen
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

  testWidgets('Flow 1 — Onboarding page 1', (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      localizedApp(home: const OnboardingScreen()),
    );
    await tester.pump(const Duration(milliseconds: 500));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/flow_01_onboarding.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Flow 2 — Alarm screen', (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      localizedApp(home: const AlarmScreen()),
    );
    await tester.pump(const Duration(milliseconds: 1000));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/flow_02_alarm.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Flow 3 — Night mode (sleep tracking)', (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      localizedApp(home: const SleepTrackingScreen()),
    );
    await tester.pump(const Duration(milliseconds: 2000));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/flow_03_night_mode.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Flow 4 — Wake-up sunrise', (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      localizedApp(home: const WakeUpScreen()),
    );
    await tester.pump(const Duration(milliseconds: 5000));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/flow_04_wake_up.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Flow 5 — Morning report', (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      localizedApp(home: const MorningReportScreen()),
    );
    await tester.pump(const Duration(milliseconds: 2500));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/flow_05_morning_report.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Flow 6 — Statistics', (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      localizedApp(home: const StatisticsScreen()),
    );
    await tester.pump(const Duration(milliseconds: 2000));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/flow_06_statistics.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
