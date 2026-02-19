import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class BellIllustration extends StatefulWidget {
  final double size;

  const BellIllustration({super.key, this.size = 200});

  @override
  State<BellIllustration> createState() => _BellIllustrationState();
}

class _BellIllustrationState extends State<BellIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
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
            painter: _BellPainter(animation: _controller.value),
            size: Size.square(widget.size),
          ),
        );
      },
    );
  }
}

class _BellPainter extends CustomPainter {
  final double animation;

  _BellPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Outer glow
    canvas.drawCircle(
      Offset(cx, cy),
      size.width * 0.42,
      Paint()
        ..color =
            AppColors.starYellow.withValues(alpha: 0.05 + animation * 0.03)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
    );

    // Notification ring pulses
    for (int i = 0; i < 2; i++) {
      final progress = ((animation + i * 0.5) % 1.0);
      final radius = size.width * 0.2 + progress * size.width * 0.22;
      final opacity = (0.25 * (1.0 - progress)).clamp(0.0, 1.0);
      canvas.drawCircle(
        Offset(cx, cy - size.height * 0.02),
        radius,
        Paint()
          ..color = AppColors.starYellow.withValues(alpha: opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }

    // Background circle
    canvas.drawCircle(
      Offset(cx, cy - size.height * 0.02),
      size.width * 0.19,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.starYellow.withValues(alpha: 0.15),
            AppColors.starYellow.withValues(alpha: 0.05),
          ],
        ).createShader(Rect.fromCircle(
            center: Offset(cx, cy - size.height * 0.02),
            radius: size.width * 0.19)),
    );

    // Bell swing angle
    final swingAngle = math.sin(animation * math.pi * 2) * 0.08;

    canvas.save();
    canvas.translate(cx, cy - size.height * 0.12);
    canvas.rotate(swingAngle);
    canvas.translate(-cx, -(cy - size.height * 0.12));

    // Bell top knob
    canvas.drawCircle(
      Offset(cx, cy - size.height * 0.18),
      size.width * 0.02,
      Paint()..color = AppColors.starYellow,
    );

    // Bell body path
    final bellPath = Path();
    final bellTop = cy - size.height * 0.16;
    final bellBottom = cy + size.height * 0.07;
    final bellWidth = size.width * 0.24;
    final bellTopWidth = size.width * 0.06;

    bellPath.moveTo(cx - bellTopWidth / 2, bellTop);
    // Left curve
    bellPath.cubicTo(
      cx - bellTopWidth / 2,
      bellTop + (bellBottom - bellTop) * 0.3,
      cx - bellWidth / 2,
      bellTop + (bellBottom - bellTop) * 0.6,
      cx - bellWidth / 2,
      bellBottom,
    );
    // Bottom
    bellPath.lineTo(cx + bellWidth / 2, bellBottom);
    // Right curve
    bellPath.cubicTo(
      cx + bellWidth / 2,
      bellTop + (bellBottom - bellTop) * 0.6,
      cx + bellTopWidth / 2,
      bellTop + (bellBottom - bellTop) * 0.3,
      cx + bellTopWidth / 2,
      bellTop,
    );
    bellPath.close();

    // Bell gradient fill
    final bellPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.starYellow,
          const Color(0xFFE8A830),
        ],
      ).createShader(
          Rect.fromLTRB(cx - bellWidth / 2, bellTop, cx + bellWidth / 2, bellBottom));
    canvas.drawPath(bellPath, bellPaint);

    // Bell glow
    canvas.drawPath(
      bellPath,
      Paint()
        ..color = AppColors.starYellow.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Bell rim (bottom edge)
    canvas.drawLine(
      Offset(cx - bellWidth / 2 - 2, bellBottom),
      Offset(cx + bellWidth / 2 + 2, bellBottom),
      Paint()
        ..color = const Color(0xFFD4952A)
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    // Clapper (ball at bottom)
    canvas.drawCircle(
      Offset(cx, bellBottom + size.height * 0.025),
      size.width * 0.025,
      Paint()..color = const Color(0xFFD4952A),
    );

    canvas.restore();

    // Small sparkles / notification indicators
    final sparkles = [
      Offset(cx + size.width * 0.22, cy - size.height * 0.15),
      Offset(cx - size.width * 0.2, cy - size.height * 0.08),
      Offset(cx + size.width * 0.18, cy + size.height * 0.1),
    ];
    for (int i = 0; i < sparkles.length; i++) {
      final phase = (animation + i * 0.33) % 1.0;
      final opacity = 0.3 + 0.5 * ((math.sin(phase * math.pi * 2) + 1) / 2);
      final sparkSize = 3.0 + i;
      final p = sparkles[i];
      // 4-point star
      final path = Path()
        ..moveTo(p.dx, p.dy - sparkSize)
        ..lineTo(p.dx + sparkSize * 0.3, p.dy)
        ..lineTo(p.dx, p.dy + sparkSize)
        ..lineTo(p.dx - sparkSize * 0.3, p.dy)
        ..close();
      final path2 = Path()
        ..moveTo(p.dx - sparkSize, p.dy)
        ..lineTo(p.dx, p.dy + sparkSize * 0.3)
        ..lineTo(p.dx + sparkSize, p.dy)
        ..lineTo(p.dx, p.dy - sparkSize * 0.3)
        ..close();
      final paint = Paint()
        ..color = AppColors.starYellow.withValues(alpha: opacity);
      canvas.drawPath(path, paint);
      canvas.drawPath(path2, paint);
    }
  }

  @override
  bool shouldRepaint(_BellPainter oldDelegate) =>
      animation != oldDelegate.animation;
}
