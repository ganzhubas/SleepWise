import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../models/sleep_stats_data.dart';

/// Horizontal scrolling strip of summary metric cards.
class SummaryCards extends StatelessWidget {
  final List<DayStat> data;

  const SummaryCards({super.key, required this.data});

  String _formatHours(double h) {
    final hours = h.floor();
    final mins = ((h - hours) * 60).round();
    return '$hoursч ${mins.toString().padLeft(2, '0')}мин';
  }

  String _formatBedtime(double h) {
    final normalized = h < 12 ? h + 24 : h;
    final hours = (normalized >= 24 ? normalized - 24 : normalized).floor();
    final mins = ((normalized - normalized.floor()) * 60).round();
    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final avgHours = SleepStatsData.averageHours(data);
    final avgBedtime = SleepStatsData.averageBedtime(data);
    final best = SleepStatsData.bestDay(data);
    final avgSnore = SleepStatsData.averageSnore(data);

    final items = <_SummaryItem>[
      _SummaryItem(
        icon: Icons.schedule_rounded,
        label: 'Среднее время сна',
        value: _formatHours(avgHours),
        color: AppColors.calmBlue,
      ),
      _SummaryItem(
        icon: Icons.nightlight_round,
        label: 'Среднее засыпание',
        value: _formatBedtime(avgBedtime),
        color: AppColors.dreamPurple,
      ),
      if (best != null)
        _SummaryItem(
          icon: Icons.emoji_events_rounded,
          label: 'Лучший день',
          value:
              '${SleepStatsData.weekdayFullRu(best.date.weekday)} (${best.score})',
          color: AppColors.starYellow,
        ),
      _SummaryItem(
        icon: Icons.volume_up_rounded,
        label: 'Храп',
        value: '${avgSnore.round()}% в среднем',
        color: AppColors.warning,
      ),
    ];

    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding:
            const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) => _buildCard(items[i]),
      ),
    );
  }

  Widget _buildCard(_SummaryItem item) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border(
          left: BorderSide(color: item.color.withValues(alpha: 0.6), width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(item.icon, size: 16, color: item.color.withValues(alpha: 0.7)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: AppColors.moonlight.withValues(alpha: 0.4),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.value,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.moonlight,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _SummaryItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}
