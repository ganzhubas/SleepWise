import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/core/theme/app_colors.dart';
import 'package:sleepwise/features/showcase/widget_showcase_screen.dart';

void main() {
  // Reusable dark theme without google_fonts (no network needed)
  final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.calmBlue,
      secondary: AppColors.dreamPurple,
      surface: AppColors.darkSurface,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.darkOnBackground,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkOnBackground,
      elevation: 0,
    ),
  );

  testWidgets('Widget showcase golden — top', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: darkTheme,
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
        theme: darkTheme,
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
