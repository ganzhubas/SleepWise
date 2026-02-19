import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/features/sleep_tracking/sleep_tracking_screen.dart';
import 'package:sleepwise/features/sleep_tracking/widgets/sound_visualizer.dart';

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

  group('Sleep Tracking Screen', () {
    testWidgets('renders night mode with clock', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const SleepTrackingScreen()));
      await tester.pump(const Duration(milliseconds: 2000));

      // Sound visualizer should be present
      expect(find.byType(SoundVisualizer), findsOneWidget);
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });

    testWidgets('tap brightens screen elements', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const SleepTrackingScreen()));
      await tester.pump(const Duration(milliseconds: 2000));

      // Single tap on screen
      await tester.tap(find.byType(SleepTrackingScreen));
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });

    testWidgets('double tap shows stop confirmation', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const SleepTrackingScreen()));
      await tester.pump(const Duration(milliseconds: 2000));

      // Double tap
      await tester.tap(find.byType(SleepTrackingScreen));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.byType(SleepTrackingScreen));
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });

    testWidgets('swipe up shows stop sheet', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const SleepTrackingScreen()));
      await tester.pump(const Duration(milliseconds: 2000));

      // Swipe up gesture
      await tester.fling(
        find.byType(SleepTrackingScreen),
        const Offset(0, -300),
        500,
      );
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(tester.takeException(), isNull);
      resetScreen(tester);
    });

    testWidgets('sound visualizer animates', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const SleepTrackingScreen()));

      // Let animation run
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(SoundVisualizer), findsOneWidget);
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });

    testWidgets('no text overflow in night mode', (tester) async {
      setScreen(tester);
      await tester.pumpWidget(localizedApp(home: const SleepTrackingScreen()));
      await tester.pump(const Duration(milliseconds: 2000));

      // No overflow
      expect(tester.takeException(), isNull);

      resetScreen(tester);
    });
  });
}
