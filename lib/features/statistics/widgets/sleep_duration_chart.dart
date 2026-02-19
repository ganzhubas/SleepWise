import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../models/sleep_stats_data.dart';
import '../../morning_report/widgets/sleep_card.dart';

/// Line chart showing sleep duration over time with 7-9h recommendation zone.
class SleepDurationChart extends StatelessWidget {
  final List<DayStat> data;
  final Animation<double> animation;

  const SleepDurationChart({
    super.key,
    required this.data,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final last7 = data.length > 7 ? data.sublist(data.length - 7) : data;

    return SleepCard(
      title: 'Длительность сна',
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          return SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minY: 4,
                maxY: 10,
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
                      reservedSize: 32,
                      interval: 1,
                      getTitlesWidget: (val, meta) {
                        if (val < 4.5 || val > 9.5) {
                          return const SizedBox.shrink();
                        }
                        final intVal = val.toInt();
                        if ((val - intVal).abs() > 0.1) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            '$intValч',
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
                // Green recommendation zone 7-9h
                rangeAnnotations: RangeAnnotations(
                  horizontalRangeAnnotations: [
                    HorizontalRangeAnnotation(
                      y1: 7,
                      y2: 9,
                      color: AppColors.success.withValues(alpha: 0.08),
                    ),
                  ],
                ),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    // Recommendation bounds — dashed lines at 7h and 9h
                    HorizontalLine(
                      y: 7,
                      color: AppColors.success.withValues(alpha: 0.3),
                      strokeWidth: 1,
                      dashArray: [6, 4],
                    ),
                    HorizontalLine(
                      y: 9,
                      color: AppColors.success.withValues(alpha: 0.3),
                      strokeWidth: 1,
                      dashArray: [6, 4],
                    ),
                  ],
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(last7.length, (i) {
                      final animatedY = 4 +
                          (last7[i].hoursSlept - 4) * animation.value;
                      return FlSpot(i.toDouble(), animatedY);
                    }),
                    isCurved: true,
                    curveSmoothness: 0.25,
                    color: AppColors.calmBlue,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        final hours = last7[index].hoursSlept;
                        final inZone = hours >= 7 && hours <= 9;
                        return FlDotCirclePainter(
                          radius: 4,
                          color: inZone ? AppColors.success : AppColors.warning,
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
                          AppColors.calmBlue.withValues(alpha: 0.15),
                          AppColors.calmBlue.withValues(alpha: 0.0),
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
                        final day = last7[spot.spotIndex];
                        return LineTooltipItem(
                          '${day.hoursSlept.toStringAsFixed(1)}ч',
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
