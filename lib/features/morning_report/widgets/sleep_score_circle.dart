import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

/// Animated circular score gauge that fills from 0 to [score] over [duration].
class SleepScoreCircle extends StatefulWidget {
  final int score;
  final double size;
  final Duration duration;

  const SleepScoreCircle({
    super.key,
    required this.score,
    this.size = 160,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<SleepScoreCircle> createState() => _SleepScoreCircleState();
}

class _SleepScoreCircleState extends State<SleepScoreCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 0, end: widget.score / 100)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static Color _scoreColor(int score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.calmBlue;
    if (score >= 40) return AppColors.warning;
    return AppColors.error;
  }

  static String _scoreLabel(int score, L l) {
    if (score >= 85) return l.scoreExcellent;
    if (score >= 70) return l.scoreGood;
    if (score >= 50) return l.scoreAverage;
    return l.scorePoor;
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final color = _scoreColor(widget.score);
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final displayScore = (_animation.value * 100).round();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: CustomPaint(
                painter: _ScoreArcPainter(
                  progress: _animation.value,
                  color: color,
                ),
                child: Center(
                  child: Text(
                    '$displayScore',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: widget.size * 0.35,
                      fontWeight: FontWeight.w700,
                      color: AppColors.moonlight,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _scoreLabel(widget.score, l),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ScoreArcPainter extends CustomPainter {
  final double progress;
  final Color color;

  _ScoreArcPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 10.0;
    const startAngle = -math.pi / 2; // 12 o'clock
    final sweepAngle = 2 * math.pi * progress;

    // Background track
    final bgPaint = Paint()
      ..color = AppColors.moonlight.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    if (progress > 0) {
      final arcPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        arcPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ScoreArcPainter old) =>
      progress != old.progress || color != old.color;
}
