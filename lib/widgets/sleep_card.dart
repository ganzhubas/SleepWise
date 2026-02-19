import 'package:flutter/material.dart';
import '../core/constants/app_dimensions.dart';

class SleepCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? accentColor;
  final VoidCallback? onTap;

  const SleepCard({
    super.key,
    required this.child,
    this.padding,
    this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: accentColor == null
              ? Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.06),
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          child: accentColor != null
              ? IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(width: 4, color: accentColor),
                      Expanded(
                        child: Padding(
                          padding: padding ??
                              const EdgeInsets.all(AppDimensions.paddingM),
                          child: child,
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding:
                      padding ?? const EdgeInsets.all(AppDimensions.paddingM),
                  child: child,
                ),
        ),
      ),
    );
  }
}
