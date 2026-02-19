import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'sleep_card.dart';

/// Card showing snore percentage and hourly mini bar chart.
///
/// When [snorePercent] is provided, shows real data.
/// Otherwise, uses hardcoded test values.
class SnoreCard extends StatelessWidget {
  final int? snorePercent;

  const SnoreCard({super.key, this.snorePercent});

  // Test data: snore intensity per hour (0-1), 23:00 → 06:00
  static const _hourlySnore = [0.0, 0.05, 0.18, 0.35, 0.12, 0.08, 0.22, 0.04];
  static const _hours = ['23', '00', '01', '02', '03', '04', '05', '06'];

  @override
  Widget build(BuildContext context) {
    final pct = snorePercent ?? 12;

    // Scale test hourly bars proportionally if real data
    final scaleFactor = snorePercent != null ? pct / 12.0 : 1.0;

    return SleepCard(
      title: 'Храп',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$pct%',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.moonlight,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'ночи',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: AppColors.moonlight.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Mini bar chart
          SizedBox(
            height: 48,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_hourlySnore.length, (i) {
                final h = (_hourlySnore[i] * scaleFactor).clamp(0.0, 1.0);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: (h * 36).clamp(2.0, 36.0),
                          decoration: BoxDecoration(
                            color: AppColors.dreamPurple
                                .withValues(alpha: 0.3 + h * 0.5),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _hours[i],
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 9,
                            color:
                                AppColors.moonlight.withValues(alpha: 0.25),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
