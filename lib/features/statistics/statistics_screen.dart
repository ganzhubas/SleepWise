import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/sleep_repository.dart';
import '../../l10n/app_localizations.dart';
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
  final _sleepRepo = SleepRepository();
  List<DayStat>? _dbData;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();
    _loadData();
  }

  bool _hasRealData = false;

  Future<void> _loadData() async {
    try {
      final sessions = await _sleepRepo.getLastSessions(90);
      if (mounted) {
        setState(() {
          _hasRealData = sessions.isNotEmpty;
          if (sessions.isNotEmpty) {
            _dbData = SleepStatsData.fromModels(sessions);
          }
        });
      }
    } catch (_) {
      // DB unavailable — keep using test data
    }
  }

  Future<void> _onRefresh() async {
    await _loadData();
    _animController
      ..reset()
      ..forward();
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
        return 30;
      case StatsPeriod.threeMonths:
        return 90;
    }
  }

  /// Returns data for the selected period: DB data if available, test fallback otherwise.
  List<DayStat> _getData() {
    final source = _dbData ?? SleepStatsData.days;
    final n = _dayCount;
    if (n >= source.length) return source;
    return source.sublist(source.length - n);
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
    final l = L.of(context);
    final data = _getData();

    // For average score: current 7 vs previous 7
    final source = _dbData ?? SleepStatsData.days;
    final current7 = source.length >= 7
        ? source.sublist(source.length - 7)
        : source;
    final previous7 = source.length >= 14
        ? source.sublist(source.length - 14, source.length - 7)
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
                l.statistics,
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

            // Scrollable content with pull-to-refresh
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors.calmBlue,
                backgroundColor: AppColors.darkSurface,
                child: _hasRealData || _dbData != null
                    ? _buildCharts(l, data, currentAvg, previousAvg, totalItems)
                    : _buildEmptyState(l),
              ),
            ),

            // Summary cards (outside scroll, pinned at bottom)
            if (_hasRealData || _dbData != null)
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

  Widget _buildCharts(L l, List<DayStat> data, double currentAvg,
      double previousAvg, int totalItems) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
      ),
      child: Column(
        children: [
          _StaggeredItem(
            animation: _stagger(0, totalItems),
            child: AverageScoreCard(
              currentAvg: currentAvg,
              previousAvg: previousAvg,
              animation: _stagger(0, totalItems),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          _StaggeredItem(
            animation: _stagger(1, totalItems),
            child: DailyScoreChart(
              data: data,
              animation: _stagger(1, totalItems),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          _StaggeredItem(
            animation: _stagger(2, totalItems),
            child: SleepDurationChart(
              data: data,
              animation: _stagger(2, totalItems),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
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
    );
  }

  Widget _buildEmptyState(L l) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.nights_stay_rounded,
              size: 72,
              color: AppColors.calmBlue.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppDimensions.paddingL),
            Text(
              l.emptyStatsTitle,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.moonlight.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingS),
            Text(
              l.emptyStatsSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                height: 1.5,
                color: AppColors.moonlight.withValues(alpha: 0.4),
              ),
            ),
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
