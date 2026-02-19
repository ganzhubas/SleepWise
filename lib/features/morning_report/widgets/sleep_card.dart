import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_colors.dart';

/// Styled card used throughout the morning report.
class SleepCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final Color? leftBorderColor;
  final EdgeInsetsGeometry padding;

  const SleepCard({
    super.key,
    required this.child,
    this.title,
    this.leftBorderColor,
    this.padding = const EdgeInsets.all(AppDimensions.paddingM),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: leftBorderColor != null
            ? Border(
                left: BorderSide(color: leftBorderColor!, width: 4),
              )
            : null,
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.moonlight.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 12),
            ],
            child,
          ],
        ),
      ),
    );
  }
}
