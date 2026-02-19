import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class PhoneIllustration extends StatefulWidget {
  final double size;

  const PhoneIllustration({super.key, this.size = 240});

  @override
  State<PhoneIllustration> createState() => _PhoneIllustrationState();
}

class _PhoneIllustrationState extends State<PhoneIllustration>
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
            painter: _PhonePainter(animation: _controller.value),
            size: Size.square(widget.size),
          ),
        );
      },
    );
  }
}

class _PhonePainter extends CustomPainter {
  final double animation;

  _PhonePainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Pillow
    final pillowRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, cy + size.height * 0.08),
        width: size.width * 0.75,
        height: size.height * 0.35,
      ),
      const Radius.circular(30),
    );
    final pillowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF2A3A5C),
          const Color(0xFF1E2D4A),
        ],
      ).createShader(pillowRect.outerRect);
    canvas.drawRRect(pillowRect, pillowPaint);

    // Pillow highlight
    final pillowHighlight = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, cy + size.height * 0.04),
        width: size.width * 0.65,
        height: size.height * 0.12,
      ),
      const Radius.circular(20),
    );
    canvas.drawRRect(
      pillowHighlight,
      Paint()..color = AppColors.calmBlue.withValues(alpha: 0.06),
    );

    // Phone body
    final phoneW = size.width * 0.28;
    final phoneH = size.height * 0.45;
    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy - size.height * 0.02), width: phoneW, height: phoneH),
      const Radius.circular(12),
    );
    canvas.drawRRect(
      phoneRect,
      Paint()..color = const Color(0xFF0A1628),
    );

    // Phone screen
    final screenRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, cy - size.height * 0.02),
        width: phoneW - 6,
        height: phoneH - 10,
      ),
      const Radius.circular(8),
    );
    final screenPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primaryMedium.withValues(alpha: 0.9),
          AppColors.nightSky,
        ],
      ).createShader(screenRect.outerRect);
    canvas.drawRRect(screenRect, screenPaint);

    // Screen glow
    canvas.drawRRect(
      screenRect,
      Paint()
        ..color = AppColors.calmBlue.withValues(alpha: 0.08 + animation * 0.05)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
    );

    // Sound waves emanating from phone
    for (int i = 0; i < 3; i++) {
      final waveProgress = ((animation + i * 0.33) % 1.0);
      final waveRadius = phoneW * 0.4 + waveProgress * size.width * 0.25;
      final waveOpacity = (0.3 * (1.0 - waveProgress)).clamp(0.0, 1.0);
      canvas.drawCircle(
        Offset(cx, cy - size.height * 0.02),
        waveRadius,
        Paint()
          ..color = AppColors.calmBlue.withValues(alpha: waveOpacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }

    // Moon icon on phone screen
    final moonCenter = Offset(cx, cy - size.height * 0.08);
    final moonR = phoneW * 0.18;
    canvas.drawCircle(
      moonCenter,
      moonR,
      Paint()..color = AppColors.starYellow.withValues(alpha: 0.9),
    );
    canvas.drawCircle(
      Offset(moonCenter.dx + moonR * 0.3, moonCenter.dy - moonR * 0.2),
      moonR * 0.8,
      Paint()..color = AppColors.primaryMedium.withValues(alpha: 0.9),
    );

    // Time text indicator on screen (simple bars)
    final barPaint = Paint()..color = AppColors.moonlight.withValues(alpha: 0.5);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy + size.height * 0.04), width: phoneW * 0.5, height: 3),
        const Radius.circular(2),
      ),
      barPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy + size.height * 0.07), width: phoneW * 0.3, height: 2),
        const Radius.circular(2),
      ),
      Paint()..color = AppColors.moonlight.withValues(alpha: 0.3),
    );

    // Small stars around
    final rng = math.Random(99);
    for (int i = 0; i < 6; i++) {
      final angle = (i / 6) * math.pi * 2;
      final dist = size.width * 0.38 + rng.nextDouble() * 15;
      final starX = cx + math.cos(angle) * dist;
      final starY = cy + math.sin(angle) * dist * 0.6 - 10;
      final phase = (animation + i * 0.15) % 1.0;
      final opacity = 0.2 + 0.5 * ((math.sin(phase * math.pi * 2) + 1) / 2);
      canvas.drawCircle(
        Offset(starX, starY),
        1.0 + rng.nextDouble(),
        Paint()
          ..color = AppColors.moonlight.withValues(alpha: opacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5),
      );
    }
  }

  @override
  bool shouldRepaint(_PhonePainter oldDelegate) =>
      animation != oldDelegate.animation;
}
