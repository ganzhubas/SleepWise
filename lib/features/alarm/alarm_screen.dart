import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_durations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/gradient_background.dart';
import '../../models/sleep_session.dart';
import '../../services/notification_service.dart';
import '../morning_report/morning_report_screen.dart';
import '../sleep_tracking/sleep_tracking_screen.dart';
import 'widgets/start_button.dart';
import 'widgets/time_picker_sheet.dart';
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
  String _greeting(L l) {
    final hour = _now.hour;
    if (hour >= 5 && hour < 12) return l.greetingMorning;
    if (hour >= 12 && hour < 18) return l.greetingDay;
    if (hour >= 18 && hour < 23) return l.greetingEvening;
    return l.greetingNight;
  }

  // "Alarm in X h Y min"
  String _timeUntilAlarm(L l) {
    final nowMin = _now.hour * 60 + _now.minute;
    final alarmMin = _alarmTime.hour * 60 + _alarmTime.minute;
    var diff = alarmMin - nowMin;
    if (diff <= 0) diff += 24 * 60;
    final h = diff ~/ 60;
    final m = diff % 60;
    if (h == 0) return l.alarmInMinutes(m);
    if (m == 0) return l.alarmInHours(h);
    return l.alarmInHoursMinutes(h, m);
  }

  // Wake window range string
  String _wakeRange(L l) {
    final endMin = _alarmTime.hour * 60 + _alarmTime.minute;
    final startMin = endMin - _wakeWindow;
    final sh = ((startMin % (24 * 60)) ~/ 60) % 24;
    final sm = (startMin % (24 * 60)) % 60;
    final eh = _alarmTime.hour;
    final em = _alarmTime.minute;
    final startFormatted =
        '${sh.toString().padLeft(2, '0')}:${sm.toString().padLeft(2, '0')}';
    final endFormatted =
        '${eh.toString().padLeft(2, '0')}:${em.toString().padLeft(2, '0')}';
    return l.alarmBetween(startFormatted, endFormatted);
  }

  void _openTimePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TimePickerSheet(
        initial: _alarmTime,
        onConfirm: (t) {
          setState(() => _alarmTime = t);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  Future<void> _onStart() async {
    // Schedule fallback alarm at upper bound of wake window (safety net)
    await NotificationService.instance.scheduleFallbackAlarm(
      alarmTime: _alarmTime,
    );

    final session = await Navigator.of(context).push<SleepSession>(
      MaterialPageRoute(
        builder: (_) => SleepTrackingScreen(
          alarmTime: _alarmTime,
          wakeWindow: _wakeWindow,
        ),
      ),
    );

    if (!mounted) return;

    // Navigate to morning report with session data (or test data if null)
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MorningReportScreen(session: session),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = L.of(context);

    final timeUntilAlarm = _timeUntilAlarm(l);

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
              _greeting(l),
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.moonlight.withValues(alpha: 0.8),
              ),
            ),

            const Spacer(flex: 2),

            // Alarm time — tappable, with animated digit transition
            GestureDetector(
              onTap: _openTimePicker,
              child: Column(
                children: [
                  _AnimatedTimeDisplay(time: _alarmTime),
                  const SizedBox(height: AppDimensions.paddingS),
                  AnimatedSwitcher(
                    duration: AppDurations.normal,
                    child: Text(
                      timeUntilAlarm,
                      key: ValueKey(timeUntilAlarm),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.calmBlue.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 1),

            // Wake window section
            Text(
              l.wakeWindowLabel(_wakeWindow),
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
              _wakeRange(l),
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
// Animated time display — slides digits up/down on change
// ─────────────────────────────────────────────────────────────────────────────

class _AnimatedTimeDisplay extends StatelessWidget {
  final TimeOfDay time;

  const _AnimatedTimeDisplay({required this.time});

  @override
  Widget build(BuildContext context) {
    final timeStr =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return AnimatedSwitcher(
      duration: AppDurations.slow,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.15),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Text(
        timeStr,
        key: ValueKey(timeStr),
        style: TextStyle(
          fontFamily: AppTypography.mono,
          fontSize: 84,
          fontWeight: FontWeight.w300,
          color: AppColors.moonlight,
          letterSpacing: 4,
          height: 1,
        ),
      ),
    );
  }
}
