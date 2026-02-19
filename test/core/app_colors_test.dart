import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/core/theme/app_colors.dart';

void main() {
  group('AppColors', () {
    test('primary palette colors are defined', () {
      expect(AppColors.primaryDark, isA<Color>());
      expect(AppColors.primaryMedium, isA<Color>());
      expect(AppColors.primaryLight, isA<Color>());
      expect(AppColors.accent, isA<Color>());
    });

    test('sleep-themed colors are defined', () {
      expect(AppColors.nightSky, isA<Color>());
      expect(AppColors.moonlight, isA<Color>());
      expect(AppColors.starYellow, isA<Color>());
      expect(AppColors.dreamPurple, isA<Color>());
      expect(AppColors.calmBlue, isA<Color>());
    });

    test('functional colors are defined', () {
      expect(AppColors.success, isA<Color>());
      expect(AppColors.warning, isA<Color>());
      expect(AppColors.error, isA<Color>());
    });

    test('light theme colors are defined', () {
      expect(AppColors.lightBackground, isA<Color>());
      expect(AppColors.lightSurface, isA<Color>());
      expect(AppColors.lightOnBackground, isA<Color>());
    });

    test('dark theme colors are defined', () {
      expect(AppColors.darkBackground, isA<Color>());
      expect(AppColors.darkSurface, isA<Color>());
      expect(AppColors.darkOnBackground, isA<Color>());
    });

    test('primary colors are dark-toned', () {
      // Primary dark should have low brightness
      expect(AppColors.primaryDark.computeLuminance(), lessThan(0.1));
      expect(AppColors.nightSky.computeLuminance(), lessThan(0.1));
    });

    test('success/warning/error are distinct', () {
      expect(AppColors.success, isNot(equals(AppColors.warning)));
      expect(AppColors.warning, isNot(equals(AppColors.error)));
      expect(AppColors.success, isNot(equals(AppColors.error)));
    });

    test('specific hex values', () {
      expect(AppColors.primaryDark, const Color(0xFF1A1A2E));
      expect(AppColors.nightSky, const Color(0xFF0D1B2A));
      expect(AppColors.calmBlue, const Color(0xFF3A86FF));
      expect(AppColors.success, const Color(0xFF06D6A0));
      expect(AppColors.error, const Color(0xFFEF476F));
    });
  });
}
