import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../morning_report/widgets/sleep_card.dart';

/// Big average score number with trend arrow and delta.
class AverageScoreCard extends StatelessWidget {
  final double currentAvg;
  final double previousAvg;
  final Animation<double> animation;

  const AverageScoreCard({
    super.key,
    required this.currentAvg,
    required this.previousAvg,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final diff = currentAvg - previousAvg;
    final isUp = diff >= 0;
    final diffAbs = diff.abs().round();
    final score = currentAvg.round();

    Color scoreColor;
    if (score >= 80) {
      scoreColor = AppColors.success;
    } else if (score >= 60) {
      scoreColor = AppColors.calmBlue;
    } else if (score >= 40) {
      scoreColor = AppColors.warning;
    } else {
      scoreColor = AppColors.error;
    }

    return SleepCard(
      title: 'Средняя оценка',
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final animatedScore = (score * animation.value).round();
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Big score number
              Text(
                '$animatedScore',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 56,
                  fontWeight: FontWeight.w700,
                  color: scoreColor,
                  height: 1,
                ),
              ),
              const SizedBox(width: 12),
              // Trend info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isUp
                                ? Icons.trending_up_rounded
                                : Icons.trending_down_rounded,
                            size: 20,
                            color: isUp ? AppColors.success : AppColors.error,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${isUp ? '↑' : '↓'} $diffAbs от прошлой недели',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isUp ? AppColors.success : AppColors.error,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Средний балл за неделю',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.moonlight.withValues(alpha: 0.35),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
