import 'package:flutter/material.dart';
import '../core/constants/app_dimensions.dart';
import '../core/constants/app_durations.dart';
import '../core/theme/app_colors.dart';

enum SleepButtonVariant { primary, secondary, outline, text }

class SleepButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final SleepButtonVariant variant;
  final IconData? icon;
  final double? width;

  const SleepButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = SleepButtonVariant.primary,
    this.icon,
    this.width,
  });

  @override
  State<SleepButton> createState() => _SleepButtonState();
}

class _SleepButtonState extends State<SleepButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.fast,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.forward();
  void _onTapUp(TapUpDetails _) => _controller.reverse();
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: _buildButton(theme, isDark),
    );
  }

  Widget _buildButton(ThemeData theme, bool isDark) {
    return switch (widget.variant) {
      SleepButtonVariant.primary => _buildPrimary(theme, isDark),
      SleepButtonVariant.secondary => _buildSecondary(theme, isDark),
      SleepButtonVariant.outline => _buildOutline(theme, isDark),
      SleepButtonVariant.text => _buildText(theme),
    };
  }

  Widget _buildPrimary(ThemeData theme, bool isDark) {
    final gradient = LinearGradient(
      colors: isDark
          ? [AppColors.calmBlue, AppColors.dreamPurple]
          : [AppColors.primaryLight, AppColors.accent],
    );

    return GestureDetector(
      onTapDown: widget.onPressed != null ? _onTapDown : null,
      onTapUp: widget.onPressed != null ? _onTapUp : null,
      onTapCancel: widget.onPressed != null ? _onTapCancel : null,
      onTap: widget.onPressed,
      child: Container(
        width: widget.width,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingL,
          vertical: AppDimensions.paddingM,
        ),
        decoration: BoxDecoration(
          gradient: widget.onPressed != null ? gradient : null,
          color: widget.onPressed == null
              ? theme.colorScheme.onSurface.withValues(alpha: 0.12)
              : null,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          boxShadow: widget.onPressed != null
              ? [
                  BoxShadow(
                    color: AppColors.calmBlue.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: AppColors.dreamPurple.withValues(alpha: 0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: _buildContent(
          theme,
          widget.onPressed != null
              ? Colors.white
              : theme.colorScheme.onSurface.withValues(alpha: 0.38),
        ),
      ),
    );
  }

  Widget _buildSecondary(ThemeData theme, bool isDark) {
    return GestureDetector(
      onTapDown: widget.onPressed != null ? _onTapDown : null,
      onTapUp: widget.onPressed != null ? _onTapUp : null,
      onTapCancel: widget.onPressed != null ? _onTapCancel : null,
      onTap: widget.onPressed,
      child: Container(
        width: widget.width,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingL,
          vertical: AppDimensions.paddingM,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurface
              : AppColors.primaryLight.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _buildContent(theme, theme.colorScheme.primary),
      ),
    );
  }

  Widget _buildOutline(ThemeData theme, bool isDark) {
    return GestureDetector(
      onTapDown: widget.onPressed != null ? _onTapDown : null,
      onTapUp: widget.onPressed != null ? _onTapUp : null,
      onTapCancel: widget.onPressed != null ? _onTapCancel : null,
      onTap: widget.onPressed,
      child: Container(
        width: widget.width,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingL,
          vertical: AppDimensions.paddingM,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.onPressed != null
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.12),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        ),
        child: _buildContent(
          theme,
          widget.onPressed != null
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withValues(alpha: 0.38),
        ),
      ),
    );
  }

  Widget _buildText(ThemeData theme) {
    return GestureDetector(
      onTapDown: widget.onPressed != null ? _onTapDown : null,
      onTapUp: widget.onPressed != null ? _onTapUp : null,
      onTapCancel: widget.onPressed != null ? _onTapCancel : null,
      onTap: widget.onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
        child: _buildContent(
          theme,
          widget.onPressed != null
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withValues(alpha: 0.38),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, Color color) {
    final children = <Widget>[
      if (widget.icon != null) ...[
        Icon(widget.icon, color: color, size: 20),
        const SizedBox(width: AppDimensions.paddingS),
      ],
      Text(
        widget.label,
        style: theme.textTheme.labelLarge?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
