import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/gradient_background.dart';
import 'models/sleep_stats_data.dart';
import 'widgets/period_selector.dart';
import 'widgets/average_score_card.dart';
import 'widgets/daily_score_chart.dart';
import 'widgets/sleep_duration_chart.dart';
import 'widgets/bedtime_chart.dart';
import 'widgets/summary_cards.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  StatsPeriod _period = StatsPeriod.week;
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onPeriodChanged(StatsPeriod p) {
    if (p == _period) return;
    setState(() => _period = p);
    _animController
      ..reset()
      ..forward();
  }

  int get _dayCount {
    switch (_period) {
      case StatsPeriod.week:
        return 7;
      case StatsPeriod.month:
        return 14; // we only have 14 days of test data
      case StatsPeriod.threeMonths:
        return 14;
    }
  }

  /// Staggered animation for item [index] out of [total].
  Animation<double> _stagger(int index, int total) {
    final start = (index / total) * 0.5;
    final end = start + 0.5;
    return CurvedAnimation(
      parent: _animController,
      curve: Interval(
        start.clamp(0, 1),
        end.clamp(0, 1),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = SleepStatsData.lastDays(_dayCount);

    // For average score: current 7 vs previous 7
    final current7 = SleepStatsData.lastDays(7);
    final previous7 = SleepStatsData.days.length >= 14
        ? SleepStatsData.days.sublist(0, 7)
        : current7;
    final currentAvg = SleepStatsData.averageScore(current7);
    final previousAvg = SleepStatsData.averageScore(previous7);

    const totalItems = 6;

    return GradientBackground(
      showStars: false,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.paddingM,
                AppDimensions.paddingM,
                AppDimensions.paddingM,
                0,
              ),
              child: Text(
                'Статистика',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.moonlight,
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.paddingM),

            // Period selector
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM),
              child: PeriodSelector(
                selected: _period,
                onChanged: _onPeriodChanged,
              ),
            ),

            const SizedBox(height: AppDimensions.paddingM),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                ),
                child: Column(
                  children: [
                    // Average score
                    _StaggeredItem(
                      animation: _stagger(0, totalItems),
                      child: AverageScoreCard(
                        currentAvg: currentAvg,
                        previousAvg: previousAvg,
                        animation: _stagger(0, totalItems),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingM),

                    // Daily score bar chart
                    _StaggeredItem(
                      animation: _stagger(1, totalItems),
                      child: DailyScoreChart(
                        data: data,
                        animation: _stagger(1, totalItems),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingM),

                    // Sleep duration line chart
                    _StaggeredItem(
                      animation: _stagger(2, totalItems),
                      child: SleepDurationChart(
                        data: data,
                        animation: _stagger(2, totalItems),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingM),

                    // Bedtime pattern chart
                    _StaggeredItem(
                      animation: _stagger(3, totalItems),
                      child: BedtimeChart(
                        data: data,
                        animation: _stagger(3, totalItems),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingL),
                  ],
                ),
              ),
            ),

            // Summary cards (outside scroll, pinned at bottom)
            _StaggeredItem(
              animation: _stagger(5, totalItems),
              child: SummaryCards(data: data),
            ),

            const SizedBox(height: AppDimensions.paddingS),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Staggered animation wrapper: slide up + fade in
// ─────────────────────────────────────────────────────────────────────────────

class _StaggeredItem extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _StaggeredItem({required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - animation.value)),
            child: child,
          ),
        );
      },
    );
  }
}
