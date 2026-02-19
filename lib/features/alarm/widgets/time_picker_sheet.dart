import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Custom dual-drum time picker bottom sheet with hours (0-23) and minutes (0-59).
class TimePickerSheet extends StatefulWidget {
  final TimeOfDay initial;
  final ValueChanged<TimeOfDay> onConfirm;

  const TimePickerSheet({
    super.key,
    required this.initial,
    required this.onConfirm,
  });

  @override
  State<TimePickerSheet> createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends State<TimePickerSheet> {
  late final FixedExtentScrollController _hourController;
  late final FixedExtentScrollController _minuteController;
  late int _selectedHour;
  late int _selectedMinute;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initial.hour;
    _selectedMinute = widget.initial.minute;
    _hourController = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController =
        FixedExtentScrollController(initialItem: _selectedMinute);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.moonlight.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),

            // Header row
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingL,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Отмена',
                      style: TextStyle(
                        color: AppColors.moonlight.withValues(alpha: 0.5),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Text(
                    'Время будильника',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.moonlight,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onConfirm(TimeOfDay(
                        hour: _selectedHour,
                        minute: _selectedMinute,
                      ));
                    },
                    child: const Text(
                      'Готово',
                      style: TextStyle(
                        color: AppColors.calmBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Dual-drum picker
            SizedBox(
              height: 220,
              child: Stack(
                children: [
                  // Center highlight strip
                  Center(
                    child: Container(
                      height: 52,
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusM,
                        ),
                        color: AppColors.calmBlue.withValues(alpha: 0.08),
                        border: Border.all(
                          color: AppColors.calmBlue.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  // Wheels row
                  Row(
                    children: [
                      const Spacer(),
                      // Hours drum
                      SizedBox(
                        width: 90,
                        child: ListWheelScrollView.useDelegate(
                          controller: _hourController,
                          physics: const FixedExtentScrollPhysics(),
                          itemExtent: 52,
                          diameterRatio: 1.5,
                          perspective: 0.003,
                          overAndUnderCenterOpacity: 0.3,
                          onSelectedItemChanged: (i) {
                            setState(() => _selectedHour = i);
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: 24,
                            builder: (context, index) {
                              final selected = index == _selectedHour;
                              return Center(
                                child: Text(
                                  index.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    fontFamily: AppTypography.mono,
                                    fontSize: selected ? 36 : 28,
                                    fontWeight: FontWeight.w300,
                                    color: selected
                                        ? AppColors.moonlight
                                        : AppColors.moonlight
                                            .withValues(alpha: 0.4),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      // Colon
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          ':',
                          style: TextStyle(
                            fontFamily: AppTypography.mono,
                            fontSize: 36,
                            fontWeight: FontWeight.w300,
                            color: AppColors.moonlight.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      // Minutes drum
                      SizedBox(
                        width: 90,
                        child: ListWheelScrollView.useDelegate(
                          controller: _minuteController,
                          physics: const FixedExtentScrollPhysics(),
                          itemExtent: 52,
                          diameterRatio: 1.5,
                          perspective: 0.003,
                          overAndUnderCenterOpacity: 0.3,
                          onSelectedItemChanged: (i) {
                            setState(() => _selectedMinute = i);
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: 60,
                            builder: (context, index) {
                              final selected = index == _selectedMinute;
                              return Center(
                                child: Text(
                                  index.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    fontFamily: AppTypography.mono,
                                    fontSize: selected ? 36 : 28,
                                    fontWeight: FontWeight.w300,
                                    color: selected
                                        ? AppColors.moonlight
                                        : AppColors.moonlight
                                            .withValues(alpha: 0.4),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
