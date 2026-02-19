import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

enum StatsPeriod { week, month, threeMonths }

/// Segmented control for switching between statistics periods.
class PeriodSelector extends StatelessWidget {
  final StatsPeriod selected;
  final ValueChanged<StatsPeriod> onChanged;

  const PeriodSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final labels = {
      StatsPeriod.week: l.period7days,
      StatsPeriod.month: l.period30days,
      StatsPeriod.threeMonths: l.period3months,
    };

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: StatsPeriod.values.map((period) {
          final isActive = period == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(period),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.calmBlue.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: isActive
                      ? Border.all(
                          color: AppColors.calmBlue.withValues(alpha: 0.4),
                          width: 1,
                        )
                      : null,
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive
                          ? AppColors.calmBlue
                          : AppColors.moonlight.withValues(alpha: 0.4),
                    ),
                    child: Text(labels[period]!),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
