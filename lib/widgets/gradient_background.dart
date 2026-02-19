import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final bool showStars;

  const GradientBackground({
    super.key,
    required this.child,
    this.showStars = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.nightSky,
            AppColors.primaryDark,
            AppColors.primaryMedium,
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: showStars
          ? Stack(
              children: [
                const Positioned.fill(child: _AnimatedStars()),
                child,
              ],
            )
          : child,
    );
  }
}

class _AnimatedStars extends StatefulWidget {
  const _AnimatedStars();

  @override
  State<_AnimatedStars> createState() => _AnimatedStarsState();
}

class _AnimatedStarsState extends State<_AnimatedStars>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Star> _stars;

  @override
  void initState() {
    super.initState();
    final rng = math.Random(42);
    _stars = List.generate(50, (_) => _Star.random(rng));
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _StarsPainter(
            stars: _stars,
            twinkle: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Star {
  final double x; // 0..1 fraction
  final double y;
  final double radius;
  final double phase; // 0..1 offset for twinkle

  _Star({
    required this.x,
    required this.y,
    required this.radius,
    required this.phase,
  });

  factory _Star.random(math.Random rng) => _Star(
        x: rng.nextDouble(),
        y: rng.nextDouble() * 0.7, // mostly in top 70%
        radius: 0.5 + rng.nextDouble() * 1.5,
        phase: rng.nextDouble(),
      );
}

class _StarsPainter extends CustomPainter {
  final List<_Star> stars;
  final double twinkle;

  _StarsPainter({required this.stars, required this.twinkle});

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final offset = (twinkle + star.phase) % 1.0;
      final opacity = 0.3 + 0.7 * ((math.sin(offset * math.pi * 2) + 1) / 2);
      final paint = Paint()
        ..color = AppColors.moonlight.withValues(alpha: opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5);
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StarsPainter oldDelegate) =>
      twinkle != oldDelegate.twinkle;
}
