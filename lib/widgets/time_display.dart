import 'package:flutter/material.dart';

class TimeDisplay extends StatelessWidget {
  final int hours;
  final int minutes;
  final bool use24HourFormat;
  final double fontSize;
  final Color? color;

  const TimeDisplay({
    super.key,
    required this.hours,
    required this.minutes,
    this.use24HourFormat = true,
    this.fontSize = 64,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = color ?? theme.colorScheme.onSurface;

    final displayHour =
        use24HourFormat ? hours : (hours == 0 ? 12 : (hours > 12 ? hours - 12 : hours));
    final period = hours >= 12 ? 'PM' : 'AM';

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '${displayHour.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: fontSize,
            fontWeight: FontWeight.w300,
            color: textColor,
            letterSpacing: 2,
            height: 1,
          ),
        ),
        if (!use24HourFormat) ...[
          const SizedBox(width: 6),
          Text(
            period,
            style: theme.textTheme.titleMedium?.copyWith(
              color: textColor.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
