import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class MicrophoneIllustration extends StatefulWidget {
  final double size;

  const MicrophoneIllustration({super.key, this.size = 200});

  @override
  State<MicrophoneIllustration> createState() =>
      _MicrophoneIllustrationState();
}

class _MicrophoneIllustrationState extends State<MicrophoneIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
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
            painter: _MicPainter(animation: _controller.value),
            size: Size.square(widget.size),
          ),
        );
      },
    );
  }
}

class _MicPainter extends CustomPainter {
  final double animation;

  _MicPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Outer glow circle
    canvas.drawCircle(
      Offset(cx, cy),
      size.width * 0.42,
      Paint()
        ..color = AppColors.calmBlue.withValues(alpha: 0.06 + animation * 0.03)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
    );

    // Animated sound wave rings
    for (int i = 0; i < 3; i++) {
      final progress = ((animation + i * 0.33) % 1.0);
      final radius = size.width * 0.18 + progress * size.width * 0.24;
      final opacity = (0.35 * (1.0 - progress)).clamp(0.0, 1.0);
      canvas.drawCircle(
        Offset(cx, cy),
        radius,
        Paint()
          ..color = AppColors.calmBlue.withValues(alpha: opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );
    }

    // Background circle for mic
    canvas.drawCircle(
      Offset(cx, cy),
      size.width * 0.18,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.calmBlue.withValues(alpha: 0.2),
            AppColors.dreamPurple.withValues(alpha: 0.1),
          ],
        ).createShader(
            Rect.fromCircle(center: Offset(cx, cy), radius: size.width * 0.18)),
    );

    // Microphone body (rounded rectangle)
    final micW = size.width * 0.09;
    final micH = size.height * 0.15;
    final micTop = cy - micH * 0.6;
    final micRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, micTop + micH / 2),
        width: micW,
        height: micH,
      ),
      Radius.circular(micW / 2),
    );
    canvas.drawRRect(
      micRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.calmBlue, AppColors.dreamPurple],
        ).createShader(micRect.outerRect),
    );

    // Mic glow
    canvas.drawRRect(
      micRect,
      Paint()
        ..color = AppColors.calmBlue.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Sound dots on mic body
    final dotPaint = Paint()..color = Colors.white.withValues(alpha: 0.4);
    for (int row = 0; row < 3; row++) {
      for (int col = -1; col <= 1; col++) {
        final dotX = cx + col * (micW * 0.22);
        final dotY = micTop + micH * 0.3 + row * (micH * 0.18);
        canvas.drawCircle(Offset(dotX, dotY), 1.2, dotPaint);
      }
    }

    // Arc (holder) around mic bottom
    final arcCenter = Offset(cx, micTop + micH * 0.7);
    final arcRadius = micW * 0.85;
    canvas.drawArc(
      Rect.fromCircle(center: arcCenter, radius: arcRadius),
      0,
      math.pi,
      false,
      Paint()
        ..color = AppColors.moonlight.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );

    // Stand line
    final standTop = arcCenter.dy + arcRadius;
    final standBottom = standTop + size.height * 0.06;
    canvas.drawLine(
      Offset(cx, standTop),
      Offset(cx, standBottom),
      Paint()
        ..color = AppColors.moonlight.withValues(alpha: 0.6)
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );

    // Base
    canvas.drawLine(
      Offset(cx - size.width * 0.06, standBottom),
      Offset(cx + size.width * 0.06, standBottom),
      Paint()
        ..color = AppColors.moonlight.withValues(alpha: 0.6)
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_MicPainter oldDelegate) =>
      animation != oldDelegate.animation;
}
