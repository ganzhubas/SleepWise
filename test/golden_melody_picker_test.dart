import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/core/theme/app_theme.dart';
import 'package:sleepwise/features/settings/melody_picker_screen.dart';

void main() {
  const screenSize = Size(1170, 2532);
  const pixelRatio = 3.0;

  testWidgets('Melody picker — top (first melodies)', (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const MelodyPickerScreen(selectedId: 'sunrise_glow'),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1500));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/melody_picker_top.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Melody picker — scrolled to bottom (custom + pro)',
      (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const MelodyPickerScreen(selectedId: 'gentle_piano'),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1500));

    // Scroll down to see last items + custom melody
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pump(const Duration(milliseconds: 300));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/melody_picker_bottom.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Melody picker — playing state with equalizer',
      (tester) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = pixelRatio;

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const MelodyPickerScreen(selectedId: 'ocean_breeze'),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1500));

    // Tap "Ocean Breeze" to start preview
    await tester.tap(find.text('Ocean Breeze'));
    await tester.pump(const Duration(milliseconds: 800));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/melody_picker_playing.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
