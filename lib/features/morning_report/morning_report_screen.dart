import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/sleep_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../models/sleep_phase.dart';
import '../../models/sleep_session.dart';
import '../../services/health_service.dart';
import 'widgets/hypnogram_chart.dart';
import 'widgets/metric_card.dart';
import 'widgets/sleep_card.dart';
import 'widgets/sleep_score_circle.dart';
import 'widgets/snore_card.dart';

/// Morning report screen shown after stopping the alarm.
///
/// When [session] is provided, displays real data and saves to database.
/// Otherwise, falls back to hardcoded test data.
class MorningReportScreen extends StatefulWidget {
  final SleepSession? session;

  const MorningReportScreen({super.key, this.session});

  @override
  State<MorningReportScreen> createState() => _MorningReportScreenState();
}

class _MorningReportScreenState extends State<MorningReportScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _staggerController;
  final _sleepRepo = SleepRepository();
  final _settingsRepo = SettingsRepository();

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();

    // Save session to DB and sync to health platforms if real data
    if (widget.session != null) {
      _saveSession();
    }
  }

  Future<void> _saveSession() async {
    final session = widget.session!;
    // Save to local DB
    await _sleepRepo.saveSleepSession(session);

    // Write to Apple Health / Health Connect if enabled
    try {
      final settings = await _settingsRepo.getSettings();
      if (settings.healthConnect || settings.samsungHealth) {
        await HealthService.instance.writeSleepSession(session);
      }
    } catch (_) {
      // Health sync failure is non-critical
    }
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  // ── Data accessors (real or test fallback) ─────────────────────────────

  int get _score => widget.session?.score ?? 82;

  String _sleepDuration(L l) {
    if (widget.session == null) return l.sleepDurationFormat(7, 24);
    final dur = widget.session!.duration;
    final h = dur.inHours;
    final m = dur.inMinutes % 60;
    return l.sleepDurationFormat(h, m);
  }

  String get _bedtimeStr {
    if (widget.session == null) return '23:14';
    final t = widget.session!.bedtime;
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  String get _wakeTimeStr {
    if (widget.session == null) return '06:52';
    final t = widget.session!.wakeTime;
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  String _inBedDuration(L l) {
    if (widget.session == null) return l.sleepDurationFormat(7, 38);
    final dur = widget.session!.duration;
    final h = dur.inHours;
    final m = dur.inMinutes % 60;
    return l.sleepDurationFormat(h, m);
  }

  String get _awakenings {
    if (widget.session == null) return '2';
    var count = 0;
    final phases = widget.session!.phases;
    for (var i = 1; i < phases.length; i++) {
      if (phases[i].type == SleepPhaseType.awake &&
          phases[i - 1].type != SleepPhaseType.awake) {
        count++;
      }
    }
    return count.toString();
  }

  int? get _snorePercent => widget.session?.snorePercentage;

  List<SleepPhase>? get _phases =>
      widget.session?.phases.isNotEmpty == true ? widget.session!.phases : null;

  DateTime? get _bedtime => widget.session?.bedtime;

  String _recommendation(L l) {
    final score = _score;
    if (score >= 80) {
      return l.recommendationExcellent;
    }
    if (score >= 60) {
      return l.recommendationGood;
    }
    return l.recommendationPoor;
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
    final l = L.of(context);
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
                      child: _buildHeroSection(l),
                    ),

                    const SizedBox(height: AppDimensions.paddingL),

                    // ── Hypnogram ──────────────────────────────────
                    _StaggeredItem(
                      animation: _staggerAnimation(1, totalItems),
                      child: SleepCard(
                        title: l.hypnogram,
                        child: HypnogramChart(
                          phases: _phases,
                          bedtime: _bedtime,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingM),

                    // ── Metrics 2×2 ────────────────────────────────
                    _StaggeredItem(
                      animation: _staggerAnimation(2, totalItems),
                      child: _buildMetricsGrid(l),
                    ),

                    const SizedBox(height: AppDimensions.paddingM),

                    // ── Snore card ─────────────────────────────────
                    _StaggeredItem(
                      animation: _staggerAnimation(3, totalItems),
                      child: SnoreCard(snorePercent: _snorePercent),
                    ),

                    const SizedBox(height: AppDimensions.paddingM),

                    // ── Recommendation ─────────────────────────────
                    _StaggeredItem(
                      animation: _staggerAnimation(4, totalItems),
                      child: _buildRecommendation(l),
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
                    child: Text(
                      l.done,
                      style: const TextStyle(
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

  Widget _buildHeroSection(L l) {
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
          SleepScoreCircle(score: _score),
          const SizedBox(height: 20),
          Text(
            _sleepDuration(l),
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.moonlight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l.sleepTimeLabel,
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

  Widget _buildMetricsGrid(L l) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MetricCard(
                icon: Icons.nightlight_round,
                label: l.fellAsleep,
                value: _bedtimeStr,
                iconColor: AppColors.dreamPurple.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingM),
            Expanded(
              child: MetricCard(
                icon: Icons.wb_sunny_rounded,
                label: l.wokeUp,
                value: _wakeTimeStr,
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
                label: l.inBed,
                value: _inBedDuration(l),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingM),
            Expanded(
              child: MetricCard(
                icon: Icons.visibility_outlined,
                label: l.awakenings,
                value: _awakenings,
                iconColor: AppColors.warning.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecommendation(L l) {
    final score = _score;
    final color = score >= 80
        ? AppColors.success
        : score >= 60
            ? AppColors.warning
            : AppColors.error;

    return SleepCard(
      leftBorderColor: color,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            size: 22,
            color: color.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _recommendation(l),
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
