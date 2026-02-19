import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_colors.dart';

/// Row of wake-window duration chips (10, 20, 30, 45, 60 min).
/// Selected chip animates scale + color smoothly.
class WakeWindowSelector extends StatelessWidget {
  final int selectedMinutes;
  final ValueChanged<int> onChanged;

  const WakeWindowSelector({
    super.key,
    required this.selectedMinutes,
    required this.onChanged,
  });

  static const _options = [10, 20, 30, 45, 60];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _options.map((min) {
        final selected = min == selectedMinutes;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: GestureDetector(
            onTap: () => onChanged(min),
            child: AnimatedScale(
              scale: selected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                  vertical: AppDimensions.paddingS,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.calmBlue
                      : AppColors.darkSurface.withValues(alpha: 0.6),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusCircular),
                  border: Border.all(
                    color: selected
                        ? AppColors.calmBlue
                        : AppColors.moonlight.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected
                        ? Colors.white
                        : AppColors.moonlight.withValues(alpha: 0.5),
                  ),
                  child: Text('$min'),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
