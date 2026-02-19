import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/core/theme/app_theme.dart';
import 'package:sleepwise/features/showcase/widget_showcase_screen.dart';

void main() {
  testWidgets('Widget showcase golden — top', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const WidgetShowcaseScreen(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1000));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/showcase_top.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Widget showcase golden — bottom (cards)',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const WidgetShowcaseScreen(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1000));

    // Scroll down to reveal SleepCard section
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pump(const Duration(milliseconds: 500));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/showcase_bottom.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
