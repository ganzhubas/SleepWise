import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Soft equalizer-style sound visualizer: 7 bars that oscillate
/// using sine waves plus noise, drawn at very low opacity.
class SoundVisualizer extends StatefulWidget {
  final int barCount;
  final double barWidth;
  final double maxHeight;

  const SoundVisualizer({
    super.key,
    this.barCount = 7,
    this.barWidth = 3,
    this.maxHeight = 28,
  });

  @override
  State<SoundVisualizer> createState() => _SoundVisualizerState();
}

class _SoundVisualizerState extends State<SoundVisualizer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _rng = math.Random(7);
  late final List<double> _phases;
  late final List<double> _speeds;

  @override
  void initState() {
    super.initState();
    _phases = List.generate(widget.barCount, (_) => _rng.nextDouble() * math.pi * 2);
    _speeds = List.generate(widget.barCount, (_) => 1.5 + _rng.nextDouble() * 2.5);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 120),
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
        final elapsed = _controller.value * 120;
        return CustomPaint(
          painter: _VisualizerPainter(
            barCount: widget.barCount,
            barWidth: widget.barWidth,
            maxHeight: widget.maxHeight,
            elapsed: elapsed,
            phases: _phases,
            speeds: _speeds,
          ),
          size: Size(
            widget.barCount * widget.barWidth + (widget.barCount - 1) * 3,
            widget.maxHeight,
          ),
        );
      },
    );
  }
}

class _VisualizerPainter extends CustomPainter {
  final int barCount;
  final double barWidth;
  final double maxHeight;
  final double elapsed;
  final List<double> phases;
  final List<double> speeds;

  _VisualizerPainter({
    required this.barCount,
    required this.barWidth,
    required this.maxHeight,
    required this.elapsed,
    required this.phases,
    required this.speeds,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final totalBarWidth = barWidth;
    final gap = 3.0;
    final totalWidth = barCount * totalBarWidth + (barCount - 1) * gap;
    final startX = (size.width - totalWidth) / 2;
    final centerY = size.height / 2;

    for (int i = 0; i < barCount; i++) {
      // Sine wave + secondary harmonic for organic motion
      final primary = math.sin(elapsed * speeds[i] + phases[i]);
      final secondary = math.sin(elapsed * speeds[i] * 0.6 + phases[i] * 1.3) * 0.3;
      final normalized = ((primary + secondary) + 1.3) / 2.6; // 0..1
      final barH = 2 + normalized * (maxHeight - 2);

      final x = startX + i * (totalBarWidth + gap);
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x + totalBarWidth / 2, centerY),
          width: totalBarWidth,
          height: barH,
        ),
        Radius.circular(totalBarWidth / 2),
      );

      // Softer bars toward edges
      final distFromCenter = (i - (barCount - 1) / 2).abs() / ((barCount - 1) / 2);
      final alpha = 0.35 - distFromCenter * 0.12;

      final paint = Paint()
        ..color = AppColors.calmBlue.withValues(alpha: alpha.clamp(0.12, 0.4));
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(_VisualizerPainter oldDelegate) =>
      elapsed != oldDelegate.elapsed;
}
