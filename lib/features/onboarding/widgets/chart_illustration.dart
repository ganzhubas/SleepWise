import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ChartIllustration extends StatefulWidget {
  final double size;

  const ChartIllustration({super.key, this.size = 240});

  @override
  State<ChartIllustration> createState() => _ChartIllustrationState();
}

class _ChartIllustrationState extends State<ChartIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();
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
            painter: _ChartPainter(animation: _controller.value),
            size: Size.square(widget.size),
          ),
        );
      },
    );
  }
}

class _ChartPainter extends CustomPainter {
  final double animation;

  _ChartPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Card background
    final cardRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy), width: size.width * 0.82, height: size.height * 0.65),
      const Radius.circular(16),
    );
    canvas.drawRRect(
      cardRect,
      Paint()
        ..color = AppColors.darkSurface
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawRRect(
      cardRect,
      Paint()..color = AppColors.darkSurface,
    );

    // Card border
    canvas.drawRRect(
      cardRect,
      Paint()
        ..color = AppColors.calmBlue.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Chart area
    final chartLeft = cx - size.width * 0.32;
    final chartRight = cx + size.width * 0.32;
    final chartTop = cy - size.height * 0.12;
    final chartBottom = cy + size.height * 0.18;
    final chartW = chartRight - chartLeft;
    final chartH = chartBottom - chartTop;

    // Title bar placeholder
    final titlePaint = Paint()..color = AppColors.moonlight.withValues(alpha: 0.7);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(chartLeft, cy - size.height * 0.24, chartW * 0.4, 4),
        const Radius.circular(2),
      ),
      titlePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(chartLeft, cy - size.height * 0.20, chartW * 0.25, 3),
        const Radius.circular(2),
      ),
      Paint()..color = AppColors.moonlight.withValues(alpha: 0.3),
    );

    // Hypnogram-like curve (sleep stages: awake, light, deep, REM)
    // Y values: 0 = awake (top), 0.33 = REM, 0.66 = light, 1 = deep (bottom)
    final stages = [
      0.0, 0.1, 0.6, 0.9, 1.0, 0.9, 0.6, 0.33, 0.5, 0.7, 1.0, 0.8,
      0.33, 0.1, 0.5, 0.8, 1.0, 0.7, 0.33, 0.0,
    ];

    final path = Path();
    final animatedCount = (stages.length * animation).floor().clamp(2, stages.length);

    for (int i = 0; i < animatedCount; i++) {
      final x = chartLeft + (i / (stages.length - 1)) * chartW;
      final y = chartTop + stages[i] * chartH;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevX = chartLeft + ((i - 1) / (stages.length - 1)) * chartW;
        final prevY = chartTop + stages[i - 1] * chartH;
        final midX = (prevX + x) / 2;
        path.cubicTo(midX, prevY, midX, y, x, y);
      }
    }

    // Gradient fill under curve
    if (animatedCount > 1) {
      final fillPath = Path.from(path);
      final lastX = chartLeft + ((animatedCount - 1) / (stages.length - 1)) * chartW;
      fillPath.lineTo(lastX, chartBottom);
      fillPath.lineTo(chartLeft, chartBottom);
      fillPath.close();

      final fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.calmBlue.withValues(alpha: 0.25),
            AppColors.dreamPurple.withValues(alpha: 0.08),
            Colors.transparent,
          ],
        ).createShader(Rect.fromLTRB(chartLeft, chartTop, chartRight, chartBottom));
      canvas.drawPath(fillPath, fillPaint);
    }

    // Draw the line
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.calmBlue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Glow on line
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.calmBlue.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Stage labels on the left
    final labelStyle = Paint()..color = AppColors.moonlight.withValues(alpha: 0.35);
    final labelPositions = [0.0, 0.33, 0.66, 1.0];
    for (final pos in labelPositions) {
      final y = chartTop + pos * chartH;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(chartLeft - 24, y - 1.5, 18, 3),
          const Radius.circular(1.5),
        ),
        labelStyle,
      );
      // Grid line
      canvas.drawLine(
        Offset(chartLeft, y),
        Offset(chartRight, y),
        Paint()
          ..color = AppColors.moonlight.withValues(alpha: 0.06)
          ..strokeWidth = 0.5,
      );
    }

    // Score circle in top right of card
    final scoreCenter = Offset(cx + size.width * 0.25, cy - size.height * 0.22);
    final scoreRadius = 16.0;
    canvas.drawArc(
      Rect.fromCircle(center: scoreCenter, radius: scoreRadius),
      -math.pi / 2,
      math.pi * 2 * 0.85 * animation,
      false,
      Paint()
        ..color = AppColors.success
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      scoreCenter,
      scoreRadius,
      Paint()
        ..color = AppColors.success.withValues(alpha: 0.08),
    );
  }

  @override
  bool shouldRepaint(_ChartPainter oldDelegate) =>
      animation != oldDelegate.animation;
}
