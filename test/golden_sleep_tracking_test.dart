import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/features/sleep_tracking/sleep_tracking_screen.dart';
import 'package:sleepwise/features/sleep_tracking/widgets/stop_tracking_sheet.dart';
import 'package:sleepwise/features/sleep_tracking/widgets/sound_visualizer.dart';

import 'helpers/localized_app.dart';

void main() {
  const screenSize = Size(1170, 2532);
  const pixelRatio = 3.0;

  testWidgets('Sleep tracking — night mode (dim clock)', (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      localizedApp(
        home: const SleepTrackingScreen(
          alarmTime: TimeOfDay(hour: 7, minute: 0),
          wakeWindow: 30,
        ),
      ),
    );
    // Let animations warm up (recording dot, visualizer)
    await tester.pump(const Duration(milliseconds: 800));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/sleep_tracking_dim.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Sleep tracking — tapped (bright clock)', (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      localizedApp(
        home: const SleepTrackingScreen(
          alarmTime: TimeOfDay(hour: 7, minute: 0),
          wakeWindow: 30,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    // Tap to brighten — pump 300ms for double-tap disambiguation + 500ms for animation
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pump(const Duration(milliseconds: 300)); // double-tap timeout
    await tester.pump(const Duration(milliseconds: 500)); // brighten animation

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/sleep_tracking_bright.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Sleep tracking — stop confirmation sheet', (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      localizedApp(
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: StopTrackingSheet(
              onStop: () {},
              onContinue: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/stop_tracking_sheet.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Sound visualizer — standalone golden', (tester) async {
    tester.view.physicalSize = const Size(600, 300);
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      localizedApp(
        home: const Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: SoundVisualizer(),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/sound_visualizer.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
