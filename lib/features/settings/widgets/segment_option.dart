import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Inline segmented control that fits inside a settings tile trailing slot.
class SegmentOption<T> extends StatelessWidget {
  final Map<T, String> options;
  final T selected;
  final ValueChanged<T> onChanged;

  const SegmentOption({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.moonlight.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.entries.map((e) {
          final isActive = e.key == selected;
          return GestureDetector(
            onTap: () => onChanged(e.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.calmBlue.withValues(alpha: 0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: isActive
                    ? Border.all(
                        color: AppColors.calmBlue.withValues(alpha: 0.3),
                        width: 0.5)
                    : null,
              ),
              child: Text(
                e.value,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                      ? AppColors.calmBlue
                      : AppColors.moonlight.withValues(alpha: 0.4),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
