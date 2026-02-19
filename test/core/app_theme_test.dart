import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/core/theme/app_colors.dart';
import 'package:sleepwise/core/theme/app_theme.dart';
import 'package:sleepwise/core/theme/app_typography.dart';

void main() {
  group('AppTheme.light', () {
    late ThemeData theme;

    setUp(() {
      theme = AppTheme.light;
    });

    test('uses Material 3', () {
      expect(theme.useMaterial3, true);
    });

    test('has light brightness', () {
      expect(theme.brightness, Brightness.light);
    });

    test('has correct scaffold background', () {
      expect(theme.scaffoldBackgroundColor, AppColors.lightBackground);
    });

    test('has correct color scheme primary', () {
      expect(theme.colorScheme.primary, AppColors.primaryLight);
    });

    test('has correct color scheme secondary', () {
      expect(theme.colorScheme.secondary, AppColors.accent);
    });

    test('has correct error color', () {
      expect(theme.colorScheme.error, AppColors.error);
    });

    test('has no app bar elevation', () {
      expect(theme.appBarTheme.elevation, 0);
    });

    test('has text theme defined', () {
      expect(theme.textTheme.displayLarge, isNotNull);
      expect(theme.textTheme.bodyMedium, isNotNull);
    });
  });

  group('AppTheme.dark', () {
    late ThemeData theme;

    setUp(() {
      theme = AppTheme.dark;
    });

    test('uses Material 3', () {
      expect(theme.useMaterial3, true);
    });

    test('has dark brightness', () {
      expect(theme.brightness, Brightness.dark);
    });

    test('has correct scaffold background', () {
      expect(theme.scaffoldBackgroundColor, AppColors.darkBackground);
    });

    test('has correct color scheme primary', () {
      expect(theme.colorScheme.primary, AppColors.calmBlue);
    });

    test('has correct color scheme secondary', () {
      expect(theme.colorScheme.secondary, AppColors.dreamPurple);
    });

    test('has correct surface color', () {
      expect(theme.colorScheme.surface, AppColors.darkSurface);
    });

    test('text theme has dark on-background color', () {
      expect(
        theme.textTheme.bodyMedium?.color,
        AppColors.darkOnBackground,
      );
    });

    test('app bar uses dark background', () {
      expect(theme.appBarTheme.backgroundColor, AppColors.darkBackground);
    });
  });

  group('AppTypography', () {
    test('textTheme has all required styles', () {
      final tt = AppTypography.textTheme;
      expect(tt.displayLarge, isNotNull);
      expect(tt.displayMedium, isNotNull);
      expect(tt.displaySmall, isNotNull);
      expect(tt.headlineMedium, isNotNull);
      expect(tt.titleLarge, isNotNull);
      expect(tt.titleMedium, isNotNull);
      expect(tt.bodyLarge, isNotNull);
      expect(tt.bodyMedium, isNotNull);
      expect(tt.bodySmall, isNotNull);
      expect(tt.labelLarge, isNotNull);
    });

    test('display styles use Montserrat', () {
      final tt = AppTypography.textTheme;
      expect(tt.displayLarge!.fontFamily, 'Montserrat');
      expect(tt.displayMedium!.fontFamily, 'Montserrat');
      expect(tt.displaySmall!.fontFamily, 'Montserrat');
    });

    test('body styles use Inter', () {
      final tt = AppTypography.textTheme;
      expect(tt.bodyLarge!.fontFamily, 'Inter');
      expect(tt.bodyMedium!.fontFamily, 'Inter');
      expect(tt.bodySmall!.fontFamily, 'Inter');
    });

    test('mono font family is JetBrainsMono', () {
      expect(AppTypography.mono, 'JetBrainsMono');
    });

    test('font sizes increase from small to large', () {
      final tt = AppTypography.textTheme;
      expect(tt.bodySmall!.fontSize!, lessThan(tt.bodyMedium!.fontSize!));
      expect(tt.bodyMedium!.fontSize!, lessThan(tt.bodyLarge!.fontSize!));
      expect(tt.titleMedium!.fontSize!, lessThan(tt.titleLarge!.fontSize!));
    });
  });
}
