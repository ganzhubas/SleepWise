import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../models/sleep_stats_data.dart';
import '../../morning_report/widgets/sleep_card.dart';

/// Line chart showing bedtime pattern over the last 7 days.
/// Y-axis: 21:00 → 02:00 (inverted so earlier = higher).
class BedtimeChart extends StatelessWidget {
  final List<DayStat> data;
  final Animation<double> animation;

  const BedtimeChart({
    super.key,
    required this.data,
    required this.animation,
  });

  /// Normalize bedtime hour: values < 12 get +24 (e.g., 1:30 → 25.5).
  double _normalizeHour(double h) => h < 12 ? h + 24 : h;

  /// Format hour value to HH:MM string.
  String _formatHour(double normalized) {
    final h = normalized >= 24 ? normalized - 24 : normalized;
    final hours = h.floor();
    final minutes = ((h - hours) * 60).round();
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final last7 = data.length > 7 ? data.sublist(data.length - 7) : data;

    // Y-axis range: 21:00 (21) to 02:00 (26)
    const minY = 21.0;
    const maxY = 26.0;

    return SleepCard(
      title: 'Время засыпания',
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          // Average bedtime for reference line
          final avgNorm = last7
                  .map((d) => _normalizeHour(d.bedtimeHour))
                  .reduce((a, b) => a + b) /
              last7.length;

          return SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                minX: 0,
                maxX: (last7.length - 1).toDouble(),
                clipData: const FlClipData.all(),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 1,
                      getTitlesWidget: (val, meta) {
                        final intVal = val.toInt();
                        if ((val - intVal).abs() > 0.1) {
                          return const SizedBox.shrink();
                        }
                        if (intVal < 22 || intVal > 25) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            _formatHour(intVal.toDouble()),
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
                      interval: 1,
                      getTitlesWidget: (val, meta) {
                        final idx = val.toInt();
                        if (idx < 0 || idx >= last7.length) {
                          return const SizedBox.shrink();
                        }
                        if ((val - idx).abs() > 0.1) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            SleepStatsData.weekdayNameRu(
                                last7[idx].date.weekday),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              color:
                                  AppColors.moonlight.withValues(alpha: 0.35),
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
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (val) => FlLine(
                    color: AppColors.moonlight.withValues(alpha: 0.06),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                // Average bedtime reference line
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: avgNorm,
                      color: AppColors.dreamPurple.withValues(alpha: 0.5),
                      strokeWidth: 1,
                      dashArray: [6, 4],
                      label: HorizontalLineLabel(
                        show: true,
                        alignment: Alignment.topRight,
                        padding: const EdgeInsets.only(right: 4, bottom: 2),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          color: AppColors.dreamPurple.withValues(alpha: 0.7),
                        ),
                        labelResolver: (_) =>
                            'Среднее ${_formatHour(avgNorm)}',
                      ),
                    ),
                  ],
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(last7.length, (i) {
                      final normalized =
                          _normalizeHour(last7[i].bedtimeHour);
                      // Animate from average line to actual value
                      final animatedY =
                          avgNorm + (normalized - avgNorm) * animation.value;
                      return FlSpot(i.toDouble(), animatedY);
                    }),
                    isCurved: true,
                    curveSmoothness: 0.25,
                    color: AppColors.dreamPurple,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: AppColors.dreamPurple,
                          strokeWidth: 2,
                          strokeColor: AppColors.darkSurface,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.dreamPurple.withValues(alpha: 0.15),
                          AppColors.dreamPurple.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    getTooltipColor: (_) =>
                        AppColors.darkSurface.withValues(alpha: 0.95),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final norm =
                            _normalizeHour(last7[spot.spotIndex].bedtimeHour);
                        return LineTooltipItem(
                          _formatHour(norm),
                          const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.moonlight,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
              duration: Duration.zero,
            ),
          );
        },
      ),
    );
  }
}
