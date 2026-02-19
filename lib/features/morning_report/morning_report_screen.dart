import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/hypnogram_chart.dart';
import 'widgets/metric_card.dart';
import 'widgets/sleep_card.dart';
import 'widgets/sleep_score_circle.dart';
import 'widgets/snore_card.dart';

/// Morning report screen shown after stopping the alarm.
/// Scrollable list of cards with staggered slide-up + fade-in animations.
class MorningReportScreen extends StatefulWidget {
  const MorningReportScreen({super.key});

  @override
  State<MorningReportScreen> createState() => _MorningReportScreenState();
}

class _MorningReportScreenState extends State<MorningReportScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  /// Build a staggered animation for item at [index] out of [total].
  Animation<double> _staggerAnimation(int index, int total) {
    final start = (index / total) * 0.6;
    final end = start + 0.4;
    return CurvedAnimation(
      parent: _staggerController,
      curve: Interval(start.clamp(0, 1), end.clamp(0, 1),
          curve: Curves.easeOutCubic),
    );
  }

  @override
  Widget build(BuildContext context) {
    const totalItems = 7;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: AppDimensions.paddingM),

                    // ── Hero section ───────────────────────────────
                    _StaggeredItem(
                      animation: _staggerAnimation(0, totalItems),
                      child: _buildHeroSection(),
                    ),

                    const SizedBox(height: AppDimensions.paddingL),

                    // ── Hypnogram ──────────────────────────────────
                    _StaggeredItem(
                      animation: _staggerAnimation(1, totalItems),
                      child: const SleepCard(
                        title: 'Гипнограмма',
                        child: HypnogramChart(),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingM),

                    // ── Metrics 2×2 ────────────────────────────────
                    _StaggeredItem(
                      animation: _staggerAnimation(2, totalItems),
                      child: _buildMetricsGrid(),
                    ),

                    const SizedBox(height: AppDimensions.paddingM),

                    // ── Snore card ─────────────────────────────────
                    _StaggeredItem(
                      animation: _staggerAnimation(3, totalItems),
                      child: const SnoreCard(),
                    ),

                    const SizedBox(height: AppDimensions.paddingM),

                    // ── Recommendation ─────────────────────────────
                    _StaggeredItem(
                      animation: _staggerAnimation(4, totalItems),
                      child: _buildRecommendation(),
                    ),

                    const SizedBox(height: AppDimensions.paddingXL),
                  ],
                ),
              ),
            ),

            // ── Bottom button ────────────────────────────────
            _StaggeredItem(
              animation: _staggerAnimation(6, totalItems),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.paddingM,
                  0,
                  AppDimensions.paddingM,
                  AppDimensions.paddingM,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _onDone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.calmBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusM),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Готово',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingXL),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.calmBlue.withValues(alpha: 0.15),
            AppColors.dreamPurple.withValues(alpha: 0.10),
          ],
        ),
      ),
      child: Column(
        children: [
          const SleepScoreCircle(score: 82),
          const SizedBox(height: 20),
          Text(
            '7ч 24мин',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.moonlight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Время сна',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.moonlight.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MetricCard(
                icon: Icons.nightlight_round,
                label: 'Заснул',
                value: '23:14',
                iconColor: AppColors.dreamPurple.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingM),
            Expanded(
              child: MetricCard(
                icon: Icons.wb_sunny_rounded,
                label: 'Проснулся',
                value: '06:52',
                iconColor: AppColors.starYellow.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.paddingM),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                icon: Icons.bed_rounded,
                label: 'В кровати',
                value: '7ч 38мин',
              ),
            ),
            const SizedBox(width: AppDimensions.paddingM),
            Expanded(
              child: MetricCard(
                icon: Icons.visibility_outlined,
                label: 'Пробуждений',
                value: '2',
                iconColor: AppColors.warning.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecommendation() {
    return SleepCard(
      leftBorderColor: AppColors.success,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            size: 22,
            color: AppColors.success.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Отличная ночь! Вы заснули быстро и спали стабильно. '
              'Попробуйте ложиться в это же время каждый день '
              'для стабильного режима.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                height: 1.5,
                color: AppColors.moonlight.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDone() {
    Navigator.of(context).popUntil((route) => route.isFirst);
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
