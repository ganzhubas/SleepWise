import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../models/sleep_stats_data.dart';
import '../../morning_report/widgets/sleep_card.dart';

/// Bar chart showing daily sleep scores for the last 7 days.
class DailyScoreChart extends StatefulWidget {
  final List<DayStat> data;
  final Animation<double> animation;

  const DailyScoreChart({
    super.key,
    required this.data,
    required this.animation,
  });

  @override
  State<DailyScoreChart> createState() => _DailyScoreChartState();
}

class _DailyScoreChartState extends State<DailyScoreChart> {
  int _touchedIndex = -1;

  Color _barColor(int score) {
    if (score >= 75) return AppColors.success;
    if (score >= 50) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    // Take last 7 entries for bar chart
    final last7 = widget.data.length > 7
        ? widget.data.sublist(widget.data.length - 7)
        : widget.data;

    return SleepCard(
      title: 'Оценка по дням',
      child: AnimatedBuilder(
        animation: widget.animation,
        builder: (context, _) {
          return SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                minY: 0,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchCallback: (event, response) {
                    if (event is FlTapUpEvent) {
                      setState(() {
                        _touchedIndex =
                            response?.spot?.touchedBarGroupIndex ?? -1;
                      });
                    }
                  },
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    getTooltipColor: (_) =>
                        AppColors.darkSurface.withValues(alpha: 0.95),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final day = last7[group.x.toInt()];
                      return BarTooltipItem(
                        '${day.score} баллов\n${day.hoursSlept.toStringAsFixed(1)}ч сна',
                        const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.moonlight,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: 25,
                      getTitlesWidget: (val, meta) {
                        if (val == 0 || val == 100) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            val.toInt().toString(),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              color:
                                  AppColors.moonlight.withValues(alpha: 0.25),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (val, meta) {
                        final idx = val.toInt();
                        if (idx < 0 || idx >= last7.length) {
                          return const SizedBox.shrink();
                        }
                        final day = last7[idx];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            SleepStatsData.weekdayNameRu(day.date.weekday),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: _touchedIndex == idx
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: _touchedIndex == idx
                                  ? AppColors.moonlight
                                  : AppColors.moonlight
                                      .withValues(alpha: 0.35),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (val) => FlLine(
                    color: AppColors.moonlight.withValues(alpha: 0.06),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(last7.length, (i) {
                  final day = last7[i];
                  final animatedValue =
                      day.score * widget.animation.value;
                  final isTouched = i == _touchedIndex;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: animatedValue,
                        width: isTouched ? 18 : 14,
                        color: _barColor(day.score)
                            .withValues(alpha: isTouched ? 1.0 : 0.8),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 100,
                          color: AppColors.moonlight.withValues(alpha: 0.04),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              duration: Duration.zero,
            ),
          );
        },
      ),
    );
  }
}
