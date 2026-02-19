import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:screen_brightness/screen_brightness.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import '../../models/sleep_sample.dart';
import '../../services/notification_service.dart';
import '../../services/sleep_tracking_service.dart';
import 'widgets/sound_visualizer.dart';
import 'widgets/stop_tracking_sheet.dart';

/// Night-mode sleep tracking screen.
///
/// Pure black OLED background, ultra-dim clock, pulsing recording indicator,
/// soft sound visualizer with real microphone data, and swipe-up / double-tap
/// to stop.
class SleepTrackingScreen extends StatefulWidget {
  final TimeOfDay alarmTime;
  final int wakeWindow;

  const SleepTrackingScreen({
    super.key,
    this.alarmTime = const TimeOfDay(hour: 7, minute: 30),
    this.wakeWindow = 30,
  });

  @override
  State<SleepTrackingScreen> createState() => _SleepTrackingScreenState();
}

class _SleepTrackingScreenState extends State<SleepTrackingScreen>
    with TickerProviderStateMixin {
  // ── Clock ──────────────────────────────────────────────────────────────
  late Timer _clockTimer;
  DateTime _now = DateTime.now();

  // ── Tap-to-brighten ────────────────────────────────────────────────
  late final AnimationController _brightenController;
  Timer? _brightenTimeout;

  // ── Recording indicator pulse ──────────────────────────────────────
  late final AnimationController _pulseController;

  // ── Battery ────────────────────────────────────────────────────────────
  int _batteryPercent = 85;

  // ── Audio tracking ─────────────────────────────────────────────────────
  final SleepTrackingService _trackingService = SleepTrackingService();
  StreamSubscription<SleepSample>? _sampleSub;
  double _liveRms = 0;
  ActivityLevel? _classification;

  @override
  void initState() {
    super.initState();

    // Clock tick every second (for live time)
    _clockTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _now = DateTime.now()),
    );

    // Tap-to-brighten: 0 = dim, 1 = bright
    _brightenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 800),
    );

    // Recording dot pulse: 0→1→0 (1.5s cycle)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _enableNightMode();
    _readBattery();
    _startAudioTracking();
  }

  Future<void> _startAudioTracking() async {
    try {
      await _trackingService.startTracking();
      _sampleSub = _trackingService.liveSamples.listen((sample) {
        if (mounted) {
          setState(() {
            _liveRms = sample.rms;
            _classification = sample.classification;
          });
        }
      });
    } catch (_) {
      // Microphone unavailable — continue with ambient visualization
    }
  }

  String _labelForActivity(ActivityLevel level, L l) {
    return switch (level) {
      ActivityLevel.silence => l.activitySilence,
      ActivityLevel.lowActivity => l.activityLightSleep,
      ActivityLevel.mediumActivity => l.activityMedium,
      ActivityLevel.highActivity => l.activityAwake,
      ActivityLevel.snoring => l.activitySnoring,
    };
  }

  Future<void> _enableNightMode() async {
    try {
      await WakelockPlus.enable();
    } catch (_) {}

    try {
      await ScreenBrightness.instance.setScreenBrightness(0.0);
    } catch (_) {}

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
      ),
    );
  }

  Future<void> _disableNightMode() async {
    try {
      await WakelockPlus.disable();
    } catch (_) {}
    try {
      await ScreenBrightness.instance.resetScreenBrightness();
    } catch (_) {}
  }

  Future<void> _readBattery() async {
    try {
      const channel = MethodChannel('dev.fluttercommunity.plus/battery');
      final level = await channel.invokeMethod<int>('getBatteryLevel');
      if (mounted) setState(() => _batteryPercent = level ?? 85);
    } catch (_) {
      if (mounted) setState(() => _batteryPercent = 85);
    }
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _brightenTimeout?.cancel();
    _brightenController.dispose();
    _pulseController.dispose();
    _sampleSub?.cancel();
    _trackingService.dispose();
    _disableNightMode();
    super.dispose();
  }

  // ── Tap-to-brighten logic ──────────────────────────────────────────────
  void _onScreenTap() {
    _brightenTimeout?.cancel();
    _brightenController.forward();
    _brightenTimeout = Timer(const Duration(seconds: 3), () {
      if (mounted) _brightenController.reverse();
    });
  }

  // ── Double-tap → confirm stop ──────────────────────────────────────────
  void _onDoubleTap() {
    _showStopSheet();
  }

  // ── Swipe up → confirm stop ────────────────────────────────────────────
  void _onVerticalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity != null && details.primaryVelocity! < -300) {
      _showStopSheet();
    }
  }

  void _showStopSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (_) => StopTrackingSheet(
        onStop: () async {
          Navigator.pop(context); // close sheet

          // Cancel fallback alarm — user woke up normally
          await NotificationService.instance.cancelFallbackAlarm();

          // Stop tracking and get session data
          final session = await _trackingService.stopTracking();

          if (mounted) {
            _disableNightMode();
            // Pass session data back when popping
            Navigator.pop(context, session);
          }
        },
        onContinue: () => Navigator.pop(context),
      ),
    );
  }

  // ── Alarm range string ─────────────────────────────────────────────────
  String _alarmRange(L l) {
    final endMin = widget.alarmTime.hour * 60 + widget.alarmTime.minute;
    final startMin = endMin - widget.wakeWindow;
    final sh = ((startMin % (24 * 60)) ~/ 60) % 24;
    final sm = (startMin % (24 * 60)) % 60;
    final eh = widget.alarmTime.hour;
    final em = widget.alarmTime.minute;
    final startFormatted =
        '${sh.toString().padLeft(2, '0')}:${sm.toString().padLeft(2, '0')}';
    final endFormatted =
        '${eh.toString().padLeft(2, '0')}:${em.toString().padLeft(2, '0')}';
    return l.alarmRange(startFormatted, endFormatted);
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final classificationLabel = _classification != null
        ? _labelForActivity(_classification!, l)
        : null;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onScreenTap,
        onDoubleTap: _onDoubleTap,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),

              // ── Clock ──────────────────────────────────────
              AnimatedBuilder(
                animation: _brightenController,
                builder: (context, _) {
                  final t = _brightenController.value;
                  // Interpolate #333333 → #666666
                  final grey = (0x33 + (0x33 * t)).round().clamp(0x33, 0x66);
                  return Text(
                    '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontFamily: AppTypography.mono,
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                      color: Color.fromARGB(255, grey, grey, grey),
                      letterSpacing: 4,
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // ── Sound visualizer with live data ─────────────
              SoundVisualizer(
                liveRms: _liveRms,
                classificationLabel: classificationLabel,
              ),

              const SizedBox(height: 40),

              // ── Recording indicator ─────────────────────────
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, _) {
                  final opacity =
                      0.3 + 0.5 * _pulseController.value; // 0.3→0.8
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.calmBlue
                              .withValues(alpha: opacity),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l.sleepTracking,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.moonlight
                              .withValues(alpha: 0.15),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const Spacer(flex: 4),

              // ── Bottom info ─────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      _alarmRange(l),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: AppColors.moonlight.withValues(alpha: 0.1),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l.battery(_batteryPercent),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: AppColors.moonlight.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
