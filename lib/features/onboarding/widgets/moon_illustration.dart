import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class MoonIllustration extends StatefulWidget {
  final double size;

  const MoonIllustration({super.key, this.size = 240});

  @override
  State<MoonIllustration> createState() => _MoonIllustrationState();
}

class _MoonIllustrationState extends State<MoonIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
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
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _MoonPainter(animation: _controller.value),
            size: Size.square(widget.size),
          ),
        );
      },
    );
  }
}

class _MoonPainter extends CustomPainter {
  final double animation;

  _MoonPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final moonRadius = size.width * 0.28;

    // Outer glow
    final glowPaint = Paint()
      ..color = AppColors.starYellow.withValues(alpha: 0.08 + animation * 0.04)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
    canvas.drawCircle(center, moonRadius + 30, glowPaint);

    // Medium glow
    final medGlowPaint = Paint()
      ..color = AppColors.starYellow.withValues(alpha: 0.12 + animation * 0.06)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(center, moonRadius + 15, medGlowPaint);

    // Moon body
    final moonPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        colors: [
          const Color(0xFFFFF8E7),
          AppColors.starYellow,
          const Color(0xFFE8A830),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: moonRadius));
    canvas.drawCircle(center, moonRadius, moonPaint);

    // Crescent shadow
    final shadowCenter = Offset(center.dx + moonRadius * 0.35, center.dy - moonRadius * 0.1);
    final crescentPaint = Paint()
      ..color = const Color(0xFF1A1A2E).withValues(alpha: 0.25);
    canvas.drawCircle(shadowCenter, moonRadius * 0.85, crescentPaint);

    // Restore moon circle to remove overflow of crescent
    canvas.save();
    final moonPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: moonRadius));
    final crescentPath = Path()
      ..addOval(Rect.fromCircle(center: shadowCenter, radius: moonRadius * 0.85));
    // Draw crescent only inside moon
    canvas.clipPath(moonPath);
    canvas.drawPath(crescentPath, Paint()..color = const Color(0x401A1A2E));
    canvas.restore();

    // Animated stars around moon
    final rng = math.Random(42);
    final starPaint = Paint()..color = AppColors.moonlight;
    for (int i = 0; i < 12; i++) {
      final angle = (i / 12) * math.pi * 2 + animation * 0.3;
      final dist = moonRadius * 1.5 + rng.nextDouble() * moonRadius * 0.8;
      final starX = center.dx + math.cos(angle) * dist;
      final starY = center.dy + math.sin(angle) * dist;
      final phase = (animation + i * 0.08) % 1.0;
      final opacity = 0.3 + 0.7 * ((math.sin(phase * math.pi * 2) + 1) / 2);
      final radius = 1.0 + rng.nextDouble() * 2.0;
      starPaint.color = AppColors.moonlight.withValues(alpha: opacity);
      starPaint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5);
      canvas.drawCircle(Offset(starX, starY), radius, starPaint);
    }

    // Small "Z"s floating up (sleep indicator)
    final zPaint = Paint()
      ..color = AppColors.moonlight.withValues(alpha: 0.4 + animation * 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 3; i++) {
      final offsetY = -moonRadius * 0.6 - i * 22.0 - animation * 8;
      final offsetX = moonRadius * 0.5 + i * 12.0;
      final zSize = 8.0 + i * 3.0;
      final zCenter = Offset(center.dx + offsetX, center.dy + offsetY);
      final opacity = (0.6 - i * 0.15).clamp(0.1, 0.8);
      zPaint.color = AppColors.calmBlue.withValues(alpha: opacity);

      final zPath = Path()
        ..moveTo(zCenter.dx - zSize / 2, zCenter.dy - zSize / 2)
        ..lineTo(zCenter.dx + zSize / 2, zCenter.dy - zSize / 2)
        ..lineTo(zCenter.dx - zSize / 2, zCenter.dy + zSize / 2)
        ..lineTo(zCenter.dx + zSize / 2, zCenter.dy + zSize / 2);
      canvas.drawPath(zPath, zPaint);
    }
  }

  @override
  bool shouldRepaint(_MoonPainter oldDelegate) =>
      animation != oldDelegate.animation;
}
