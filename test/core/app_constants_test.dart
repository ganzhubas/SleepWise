import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/core/constants/app_dimensions.dart';
import 'package:sleepwise/core/constants/app_durations.dart';
import 'package:sleepwise/core/constants/app_strings.dart';

void main() {
  group('AppDimensions', () {
    test('padding values increase', () {
      expect(AppDimensions.paddingXS, lessThan(AppDimensions.paddingS));
      expect(AppDimensions.paddingS, lessThan(AppDimensions.paddingM));
      expect(AppDimensions.paddingM, lessThan(AppDimensions.paddingL));
      expect(AppDimensions.paddingL, lessThan(AppDimensions.paddingXL));
      expect(AppDimensions.paddingXL, lessThan(AppDimensions.paddingXXL));
    });

    test('radius values increase', () {
      expect(AppDimensions.radiusS, lessThan(AppDimensions.radiusM));
      expect(AppDimensions.radiusM, lessThan(AppDimensions.radiusL));
      expect(AppDimensions.radiusL, lessThan(AppDimensions.radiusXL));
      expect(AppDimensions.radiusXL, lessThan(AppDimensions.radiusCircular));
    });

    test('icon sizes increase', () {
      expect(AppDimensions.iconS, lessThan(AppDimensions.iconM));
      expect(AppDimensions.iconM, lessThan(AppDimensions.iconL));
      expect(AppDimensions.iconL, lessThan(AppDimensions.iconXL));
    });

    test('specific values', () {
      expect(AppDimensions.paddingXS, 4.0);
      expect(AppDimensions.paddingS, 8.0);
      expect(AppDimensions.paddingM, 16.0);
      expect(AppDimensions.paddingL, 24.0);
      expect(AppDimensions.paddingXL, 32.0);
      expect(AppDimensions.paddingXXL, 48.0);
      expect(AppDimensions.clockSize, 280.0);
      expect(AppDimensions.alarmHandleSize, 40.0);
    });
  });

  group('AppDurations', () {
    test('durations increase', () {
      expect(AppDurations.fast.inMilliseconds, lessThan(AppDurations.normal.inMilliseconds));
      expect(AppDurations.normal.inMilliseconds, lessThan(AppDurations.slow.inMilliseconds));
      expect(AppDurations.slow.inMilliseconds, lessThan(AppDurations.verySlow.inMilliseconds));
    });

    test('specific values', () {
      expect(AppDurations.fast, const Duration(milliseconds: 150));
      expect(AppDurations.normal, const Duration(milliseconds: 300));
      expect(AppDurations.slow, const Duration(milliseconds: 500));
      expect(AppDurations.verySlow, const Duration(milliseconds: 800));
      expect(AppDurations.pageTransition, const Duration(milliseconds: 350));
      expect(AppDurations.snoozeDuration, const Duration(minutes: 5));
      expect(AppDurations.trackingInterval, const Duration(seconds: 30));
    });
  });

  group('AppStrings', () {
    test('appName is SleepWise', () {
      expect(AppStrings.appName, 'SleepWise');
    });

    test('onboarding strings are non-empty', () {
      expect(AppStrings.onboardingTitle1, isNotEmpty);
      expect(AppStrings.onboardingTitle2, isNotEmpty);
      expect(AppStrings.onboardingTitle3, isNotEmpty);
    });

    test('alarm strings are non-empty', () {
      expect(AppStrings.setAlarm, isNotEmpty);
      expect(AppStrings.alarmTime, isNotEmpty);
      expect(AppStrings.cancelAlarm, isNotEmpty);
    });

    test('tracking strings are non-empty', () {
      expect(AppStrings.startTracking, isNotEmpty);
      expect(AppStrings.stopTracking, isNotEmpty);
      expect(AppStrings.nightMode, isNotEmpty);
    });

    test('report strings are non-empty', () {
      expect(AppStrings.sleepReport, isNotEmpty);
      expect(AppStrings.sleepDuration, isNotEmpty);
      expect(AppStrings.sleepQuality, isNotEmpty);
    });

    test('navigation strings are non-empty', () {
      expect(AppStrings.statistics, isNotEmpty);
      expect(AppStrings.settings, isNotEmpty);
    });
  });
}
