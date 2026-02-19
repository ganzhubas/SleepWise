import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import '../morning_report/morning_report_screen.dart';
import 'widgets/sunrise_background.dart';
import 'widgets/stop_alarm_button.dart';
import 'widgets/swipe_to_stop.dart';

/// Wake-up alarm screen with animated sunrise gradient, stop button,
/// swipe-to-dismiss slider, snooze, gradual sound ramp and vibration.
class WakeUpScreen extends StatefulWidget {
  /// If true, show swipe slider instead of tap-to-stop button.
  final bool useSwipeToStop;
  final int maxSnoozeCount;

  const WakeUpScreen({
    super.key,
    this.useSwipeToStop = false,
    this.maxSnoozeCount = 3,
  });

  @override
  State<WakeUpScreen> createState() => _WakeUpScreenState();
}

class _WakeUpScreenState extends State<WakeUpScreen>
    with TickerProviderStateMixin {
  // ── Clock ──────────────────────────────────────────────────────────────
  late Timer _clockTimer;
  DateTime _now = DateTime.now();

  // ── "Доброе утро!" fade-in ─────────────────────────────────────────────
  late final AnimationController _greetingController;
  Timer? _greetingDelayTimer;

  // ── Snooze ─────────────────────────────────────────────────────────────
  int _snoozeRemaining = 0;

  // ── Sound ──────────────────────────────────────────────────────────────
  AudioPlayer? _player;
  Timer? _volumeRampTimer;
  double _currentVolume = 0;

  // ── Vibration ──────────────────────────────────────────────────────────
  Timer? _vibrationTimer;

  @override
  void initState() {
    super.initState();
    _snoozeRemaining = widget.maxSnoozeCount;

    _clockTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _now = DateTime.now()),
    );

    // Greeting fade-in after 2 seconds
    _greetingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _greetingDelayTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) _greetingController.forward();
    });

    _startAlarmSound();
    _startVibration();
  }

  // ── Sound: gradual volume ramp over 18 seconds ─────────────────────────
  Future<void> _startAlarmSound() async {
    try {
      _player = AudioPlayer();
      final p = _player!;
      await p.setReleaseMode(ReleaseMode.loop);
      await p.setVolume(0);
      await p.play(AssetSource('audio/alarm_tone.mp3'));
    } catch (_) {
      // Audio not available (test environment / missing asset)
      _player = null;
      return;
    }

    // Ramp volume from 0 → 1 over 18 seconds (every 500ms step)
    const steps = 36;
    const interval = Duration(milliseconds: 500);
    _volumeRampTimer = Timer.periodic(interval, (timer) {
      _currentVolume = (timer.tick / steps).clamp(0.0, 1.0);
      try {
        _player?.setVolume(_currentVolume);
      } catch (_) {}
      if (timer.tick >= steps) timer.cancel();
    });
  }

  void _startVibration() {
    _vibrationTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      try {
        HapticFeedback.vibrate();
      } catch (_) {}
    });
  }

  void _stopAlarm() {
    _volumeRampTimer?.cancel();
    _vibrationTimer?.cancel();
    try {
      _player?.stop();
    } catch (_) {}
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _greetingDelayTimer?.cancel();
    _greetingController.dispose();
    _stopAlarm();
    try {
      _player?.dispose();
    } catch (_) {}
    super.dispose();
  }

  void _onStop() {
    _stopAlarm();
    // Navigate to morning report, replacing the entire wake-up stack
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MorningReportScreen()),
        (route) => route.isFirst,
      );
    }
  }

  void _onSnooze() {
    if (_snoozeRemaining <= 0) return;
    setState(() => _snoozeRemaining--);
    _stopAlarm();
    // In production: schedule alarm for +5 min and pop back to tracking
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final timeStr =
        '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}';

    return PopScope(
      canPop: false, // prevent back-button dismissal
      child: SunriseBackground(
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ── Clock ──────────────────────────────────────
              Text(
                timeStr,
                style: TextStyle(
                  fontFamily: AppTypography.mono,
                  fontSize: 64,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  letterSpacing: 4,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Greeting (fade-in) ─────────────────────────
              FadeTransition(
                opacity: CurvedAnimation(
                  parent: _greetingController,
                  curve: Curves.easeOut,
                ),
                child: Text(
                  l.goodMorning,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.9),
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // ── Stop control ────────────────────────────────
              if (widget.useSwipeToStop)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: SwipeToStop(onStopped: _onStop),
                )
              else
                StopAlarmButton(onPressed: _onStop),

              const SizedBox(height: 48),

              // ── Snooze ──────────────────────────────────────
              if (_snoozeRemaining > 0)
                GestureDetector(
                  onTap: _onSnooze,
                  child: Column(
                    children: [
                      Text(
                        l.snoozeButton,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l.snoozeRemaining(_snoozeRemaining, widget.maxSnoozeCount),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.35),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  l.noSnoozeLeft,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
