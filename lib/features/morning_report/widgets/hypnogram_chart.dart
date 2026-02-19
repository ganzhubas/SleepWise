import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/sleep_phase.dart';

/// Sleep stage hypnogram using fl_chart AreaChart.
/// Stages: 0=Deep, 1=Light, 2=REM, 3=Awake
///
/// When [phases] is provided, converts real phase data to chart points.
/// Otherwise, uses hardcoded test data.
class HypnogramChart extends StatelessWidget {
  final List<SleepPhase>? phases;
  final DateTime? bedtime;

  const HypnogramChart({super.key, this.phases, this.bedtime});

  // Test data: typical 5-cycle night from 23:00 to 07:00 (8 hours = 480 min)
  static const _testData = <_Stage>[
    _Stage(0, 3),   _Stage(10, 2),  _Stage(18, 1),
    _Stage(30, 0),  _Stage(55, 0),  _Stage(65, 1),  _Stage(80, 2),
    _Stage(95, 1),
    _Stage(110, 0), _Stage(135, 0), _Stage(150, 1), _Stage(165, 2),
    _Stage(180, 2), _Stage(190, 1),
    _Stage(210, 0), _Stage(230, 0), _Stage(245, 1), _Stage(260, 2),
    _Stage(275, 2), _Stage(285, 1),
    _Stage(290, 3), _Stage(295, 1),
    _Stage(310, 0), _Stage(325, 1), _Stage(340, 2), _Stage(355, 2),
    _Stage(365, 1),
    _Stage(380, 1), _Stage(400, 2), _Stage(415, 2), _Stage(425, 1),
    _Stage(435, 3), _Stage(440, 1),
    _Stage(460, 2), _Stage(470, 1), _Stage(478, 3),
  ];

  static const _stageColors = {
    0: Color(0xFF1A3A6B),
    1: AppColors.calmBlue,
    2: AppColors.dreamPurple,
    3: Color(0xFFE07A5F),
  };

  static const _stageLabels = ['Глубокий', 'Лёгкий', 'REM', 'Бодрств.'];

  List<_Stage> _buildData() {
    if (phases == null || phases!.isEmpty) return _testData;

    final base = bedtime ?? phases!.first.startTime;
    final stages = <_Stage>[];

    for (final phase in phases!) {
      final startMin = phase.startTime.difference(base).inMinutes;
      final endMin = phase.endTime.difference(base).inMinutes;
      final stageIdx = _phaseTypeToStage(phase.type);

      stages.add(_Stage(startMin, stageIdx));
      if (endMin > startMin) {
        stages.add(_Stage(endMin, stageIdx));
      }
    }

    if (stages.isEmpty) return _testData;
    stages.sort((a, b) => a.minute.compareTo(b.minute));
    return stages;
  }

  static int _phaseTypeToStage(SleepPhaseType type) {
    return switch (type) {
      SleepPhaseType.deep => 0,
      SleepPhaseType.light => 1,
      SleepPhaseType.rem => 2,
      SleepPhaseType.awake => 3,
    };
  }

  int _startHour() {
    if (bedtime != null) return bedtime!.hour;
    return 23;
  }

  @override
  Widget build(BuildContext context) {
    final data = _buildData();
    final maxX = data.isEmpty ? 480.0 : data.last.minute.toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Legend
        Row(
          children: [
            for (int i = 0; i < 4; i++) ...[
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _stageColors[i],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                _stageLabels[i],
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  color: AppColors.moonlight.withValues(alpha: 0.45),
                ),
              ),
              if (i < 3) const SizedBox(width: 12),
            ],
          ],
        ),
        const SizedBox(height: 12),
        // Chart
        SizedBox(
          height: 140,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: maxX,
              minY: -0.3,
              maxY: 3.3,
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 52,
                    interval: 1,
                    getTitlesWidget: (val, meta) {
                      final idx = val.round();
                      if (idx < 0 || idx > 3) return const SizedBox.shrink();
                      if ((val - idx).abs() > 0.1) return const SizedBox.shrink();
                      final label = _stageLabels[idx];
                      return Text(
                        label,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 9,
                          color: AppColors.moonlight.withValues(alpha: 0.3),
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 60,
                    reservedSize: 22,
                    getTitlesWidget: (val, meta) {
                      final min = val.round();
                      final hour = ((_startHour() * 60 + min) ~/ 60) % 24;
                      final label = '${hour.toString().padLeft(2, '0')}:00';
                      return Text(
                        label,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 9,
                          color: AppColors.moonlight.withValues(alpha: 0.3),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: data.map((s) => FlSpot(s.minute.toDouble(), s.stage.toDouble())).toList(),
                  isCurved: true,
                  curveSmoothness: 0.3,
                  color: AppColors.calmBlue,
                  barWidth: 2,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.calmBlue.withValues(alpha: 0.25),
                        AppColors.dreamPurple.withValues(alpha: 0.08),
                      ],
                    ),
                  ),
                ),
              ],
              lineTouchData: const LineTouchData(enabled: false),
            ),
          ),
        ),
      ],
    );
  }
}

class _Stage {
  final int minute;
  final int stage;
  const _Stage(this.minute, this.stage);
}
