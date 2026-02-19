import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Grouped section of settings tiles with optional header label.
class SettingsGroup extends StatelessWidget {
  final String? label;
  final List<Widget> children;

  const SettingsGroup({
    super.key,
    this.label,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              label!.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.8,
                color: AppColors.moonlight.withValues(alpha: 0.3),
              ),
            ),
          ),
        ],
        Container(
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: Column(
            children: _withDividers(children),
          ),
        ),
      ],
    );
  }

  List<Widget> _withDividers(List<Widget> items) {
    final result = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      result.add(items[i]);
      if (i < items.length - 1) {
        result.add(
          Padding(
            padding: const EdgeInsets.only(left: 56),
            child: Divider(
              height: 0.5,
              thickness: 0.5,
              color: AppColors.moonlight.withValues(alpha: 0.06),
            ),
          ),
        );
      }
    }
    return result;
  }
}
