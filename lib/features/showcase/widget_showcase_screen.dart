import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/sleep_button.dart';
import '../../widgets/sleep_card.dart';
import '../../widgets/sleep_score_circle.dart';
import '../../widgets/time_display.dart';

class WidgetShowcaseScreen extends StatelessWidget {
  const WidgetShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            children: [
              // Title
              Text(
                'Widget Showcase',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: AppColors.moonlight,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXL),

              // --- TimeDisplay ---
              _SectionTitle('TimeDisplay'),
              const SizedBox(height: AppDimensions.paddingS),
              const Center(
                child: TimeDisplay(
                  hours: 7,
                  minutes: 30,
                  color: AppColors.moonlight,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              const Center(
                child: FittedBox(
                  child: TimeDisplay(
                    hours: 23,
                    minutes: 45,
                    use24HourFormat: false,
                    fontSize: 48,
                    color: AppColors.calmBlue,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXL),

              // --- SleepScoreCircle ---
              _SectionTitle('SleepScoreCircle'),
              const SizedBox(height: AppDimensions.paddingM),
              LayoutBuilder(
                builder: (context, constraints) {
                  final circleSize = (constraints.maxWidth - 32) / 3;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SleepScoreCircle(score: 92, size: circleSize),
                      SleepScoreCircle(score: 65, size: circleSize),
                      SleepScoreCircle(score: 35, size: circleSize),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppDimensions.paddingXL),

              // --- SleepButton ---
              _SectionTitle('SleepButton'),
              const SizedBox(height: AppDimensions.paddingM),
              Center(
                child: SleepButton(
                  label: 'Start Sleep',
                  icon: Icons.nightlight_round,
                  onPressed: () {},
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              Center(
                child: SleepButton(
                  label: 'Secondary',
                  variant: SleepButtonVariant.secondary,
                  icon: Icons.alarm,
                  onPressed: () {},
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              Row(
                children: [
                  Expanded(
                    child: SleepButton(
                      label: 'Outline',
                      variant: SleepButtonVariant.outline,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingM),
                  Expanded(
                    child: SleepButton(
                      label: 'Text',
                      variant: SleepButtonVariant.text,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingS),
              const Center(
                child: SleepButton(
                  label: 'Disabled',
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXL),

              // --- SleepCard ---
              _SectionTitle('SleepCard'),
              const SizedBox(height: AppDimensions.paddingM),
              SleepCard(
                child: Row(
                  children: [
                    const Icon(Icons.bedtime, color: AppColors.calmBlue),
                    const SizedBox(width: AppDimensions.paddingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sleep Duration',
                              style: theme.textTheme.titleMedium),
                          Text('7h 45min',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              SleepCard(
                accentColor: AppColors.success,
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.success),
                    const SizedBox(width: AppDimensions.paddingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sleep Goal Achieved!',
                              style: theme.textTheme.titleMedium),
                          Text('You slept 8 hours — great job!',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              SleepCard(
                accentColor: AppColors.warning,
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber, color: AppColors.warning),
                    const SizedBox(width: AppDimensions.paddingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Restless Night',
                              style: theme.textTheme.titleMedium),
                          Text('You woke up 3 times',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.starYellow,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}
