import 'package:flutter/material.dart';

/// Animated sunrise gradient background.
///
/// Over [duration] (default 10s), transitions from night sky through
/// twilight and dawn to a warm sunrise palette.
class SunriseBackground extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const SunriseBackground({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 10),
  });

  @override
  State<SunriseBackground> createState() => _SunriseBackgroundState();
}

class _SunriseBackgroundState extends State<SunriseBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Gradient keyframes: night → twilight → dawn → sunrise
  static const _stages = [
    // 0.0 — night
    [Color(0xFF0D1B2A), Color(0xFF0D1B2A), Color(0xFF0D1B2A)],
    // 0.3 — twilight
    [Color(0xFF0D1B2A), Color(0xFF1A1A4E), Color(0xFF2A1B3D)],
    // 0.55 — pre-dawn
    [Color(0xFF1A1A4E), Color(0xFF4A3060), Color(0xFF6B3A5E)],
    // 0.75 — dawn
    [Color(0xFF4A3060), Color(0xFFD4725E), Color(0xFFFF8C42)],
    // 1.0 — sunrise
    [Color(0xFFFF8C42), Color(0xFFFFAA5C), Color(0xFFFFB74D)],
  ];
  static const _stops = [0.0, 0.3, 0.55, 0.75, 1.0];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Interpolate between gradient stages based on [t] (0..1).
  List<Color> _interpolateColors(double t) {
    // Find the two stages we're between
    int lo = 0;
    for (int i = 0; i < _stops.length - 1; i++) {
      if (t >= _stops[i]) lo = i;
    }
    final hi = (lo + 1).clamp(0, _stops.length - 1);
    final segT = _stops[hi] == _stops[lo]
        ? 1.0
        : ((t - _stops[lo]) / (_stops[hi] - _stops[lo])).clamp(0.0, 1.0);

    return List.generate(3, (i) {
      return Color.lerp(_stages[lo][i], _stages[hi][i], segT)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final colors = _interpolateColors(_controller.value);
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors,
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
