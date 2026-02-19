import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// iOS-style settings tile with colored icon circle on the left.
/// Supports: navigation (chevron), toggle (switch), and custom trailing.
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isFirst;
  final bool isLast;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  /// Navigation tile with chevron.
  factory SettingsTile.navigation({
    Key? key,
    required IconData icon,
    required Color iconBgColor,
    required String title,
    String? value,
    VoidCallback? onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return SettingsTile(
      key: key,
      icon: icon,
      iconBgColor: iconBgColor,
      title: title,
      subtitle: value,
      onTap: onTap,
      isFirst: isFirst,
      isLast: isLast,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.moonlight.withValues(alpha: 0.35),
              ),
            ),
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: AppColors.moonlight.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }

  /// Toggle tile with switch.
  factory SettingsTile.toggle({
    Key? key,
    required IconData icon,
    required Color iconBgColor,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return SettingsTile(
      key: key,
      icon: icon,
      iconBgColor: iconBgColor,
      title: title,
      subtitle: subtitle,
      isFirst: isFirst,
      isLast: isLast,
      trailing: SizedBox(
        height: 28,
        child: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.calmBlue,
          activeTrackColor: AppColors.calmBlue.withValues(alpha: 0.4),
          inactiveThumbColor: AppColors.moonlight.withValues(alpha: 0.4),
          inactiveTrackColor: AppColors.moonlight.withValues(alpha: 0.1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(isFirst ? AppDimensions.radiusM : 0),
      topRight: Radius.circular(isFirst ? AppDimensions.radiusM : 0),
      bottomLeft: Radius.circular(isLast ? AppDimensions.radiusM : 0),
      bottomRight: Radius.circular(isLast ? AppDimensions.radiusM : 0),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        splashColor: AppColors.calmBlue.withValues(alpha: 0.08),
        highlightColor: AppColors.calmBlue.withValues(alpha: 0.04),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 11,
          ),
          child: Row(
            children: [
              // Colored icon circle
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(icon, size: 17, color: Colors.white),
              ),
              const SizedBox(width: 12),
              // Title + optional subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.moonlight,
                      ),
                    ),
                    if (subtitle != null && trailing is! Row) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.moonlight.withValues(alpha: 0.35),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}
