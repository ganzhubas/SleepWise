import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/gradient_background.dart';
import 'widgets/start_button.dart';
import 'widgets/wake_window_selector.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  TimeOfDay _alarmTime = const TimeOfDay(hour: 7, minute: 30);
  int _wakeWindow = 30;
  late Timer _clockTimer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => setState(() => _now = DateTime.now()),
    );
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  // Greeting based on hour
  String get _greeting {
    final hour = _now.hour;
    if (hour >= 5 && hour < 12) return 'Доброе утро';
    if (hour >= 12 && hour < 18) return 'Добрый день';
    if (hour >= 18 && hour < 23) return 'Добрый вечер';
    return 'Доброй ночи';
  }

  // "Alarm in X h Y min"
  String get _timeUntilAlarm {
    final nowMin = _now.hour * 60 + _now.minute;
    final alarmMin = _alarmTime.hour * 60 + _alarmTime.minute;
    var diff = alarmMin - nowMin;
    if (diff <= 0) diff += 24 * 60;
    final h = diff ~/ 60;
    final m = diff % 60;
    if (h == 0) return 'Будильник через $m мин';
    if (m == 0) return 'Будильник через $h ч';
    return 'Будильник через $h ч $m мин';
  }

  // Wake window range string
  String get _wakeRange {
    final endMin = _alarmTime.hour * 60 + _alarmTime.minute;
    final startMin = endMin - _wakeWindow;
    final sh = ((startMin % (24 * 60)) ~/ 60) % 24;
    final sm = (startMin % (24 * 60)) % 60;
    final eh = _alarmTime.hour;
    final em = _alarmTime.minute;
    return 'Будильник сработает между '
        '${sh.toString().padLeft(2, '0')}:${sm.toString().padLeft(2, '0')}'
        ' и '
        '${eh.toString().padLeft(2, '0')}:${em.toString().padLeft(2, '0')}';
  }

  void _openTimePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _TimePickerSheet(
        initial: _alarmTime,
        onConfirm: (t) {
          setState(() => _alarmTime = t);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _onStart() {
    // TODO: transition to sleep tracking / night mode
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GradientBackground(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppDimensions.paddingM),

            // Current time + greeting
            Text(
              '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.moonlight.withValues(alpha: 0.45),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXS),
            Text(
              _greeting,
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.moonlight.withValues(alpha: 0.8),
              ),
            ),

            const Spacer(flex: 2),

            // Alarm time — tappable
            GestureDetector(
              onTap: _openTimePicker,
              child: Column(
                children: [
                  Text(
                    '${_alarmTime.hour.toString().padLeft(2, '0')}:${_alarmTime.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontFamily: AppTypography.mono,
                      fontSize: 84,
                      fontWeight: FontWeight.w300,
                      color: AppColors.moonlight,
                      letterSpacing: 4,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingS),
                  Text(
                    _timeUntilAlarm,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.calmBlue.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 1),

            // Wake window section
            Text(
              'Окно пробуждения: $_wakeWindow мин',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.moonlight.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingM),
            WakeWindowSelector(
              selectedMinutes: _wakeWindow,
              onChanged: (v) => setState(() => _wakeWindow = v),
            ),
            const SizedBox(height: AppDimensions.paddingS),
            Text(
              _wakeRange,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.moonlight.withValues(alpha: 0.3),
              ),
            ),

            const Spacer(flex: 2),

            // START button
            StartButton(onPressed: _onStart),

            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Cupertino-style time picker bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

class _TimePickerSheet extends StatefulWidget {
  final TimeOfDay initial;
  final ValueChanged<TimeOfDay> onConfirm;

  const _TimePickerSheet({required this.initial, required this.onConfirm});

  @override
  State<_TimePickerSheet> createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends State<_TimePickerSheet> {
  late Duration _selected;

  @override
  void initState() {
    super.initState();
    _selected = Duration(
      hours: widget.initial.hour,
      minutes: widget.initial.minute,
    );
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

            // Header
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
                      final h = _selected.inHours % 24;
                      final m = _selected.inMinutes % 60;
                      widget.onConfirm(TimeOfDay(hour: h, minute: m));
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

            // Picker
            SizedBox(
              height: 216,
              child: CupertinoTheme(
                data: const CupertinoThemeData(
                  brightness: Brightness.dark,
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      color: AppColors.moonlight,
                      fontSize: 22,
                    ),
                  ),
                ),
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
                  initialTimerDuration: _selected,
                  onTimerDurationChanged: (d) => _selected = d,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
