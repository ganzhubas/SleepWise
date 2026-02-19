import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Soft equalizer-style sound visualizer: 7 bars that oscillate
/// using sine waves plus noise, drawn at very low opacity.
///
/// When [liveRms] is provided (> 0), the bars react to real audio amplitude.
/// Otherwise, falls back to ambient sine-wave animation.
class SoundVisualizer extends StatefulWidget {
  final int barCount;
  final double barWidth;
  final double maxHeight;

  /// Live RMS amplitude from microphone, 0.0–1.0.
  /// When > 0, bars scale to real audio levels.
  final double liveRms;

  /// Live classification label (shown as subtle text below bars).
  final String? classificationLabel;

  const SoundVisualizer({
    super.key,
    this.barCount = 7,
    this.barWidth = 3,
    this.maxHeight = 28,
    this.liveRms = 0,
    this.classificationLabel,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
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
                liveRms: widget.liveRms,
              ),
              size: Size(
                widget.barCount * widget.barWidth + (widget.barCount - 1) * 3,
                widget.maxHeight,
              ),
            );
          },
        ),
        if (widget.classificationLabel != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.classificationLabel!,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: AppColors.moonlight.withValues(alpha: 0.12),
              letterSpacing: 1.5,
            ),
          ),
        ],
      ],
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
  final double liveRms;

  _VisualizerPainter({
    required this.barCount,
    required this.barWidth,
    required this.maxHeight,
    required this.elapsed,
    required this.phases,
    required this.speeds,
    this.liveRms = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final totalBarWidth = barWidth;
    const gap = 3.0;
    final totalWidth = barCount * totalBarWidth + (barCount - 1) * gap;
    final startX = (size.width - totalWidth) / 2;
    final centerY = size.height / 2;

    for (int i = 0; i < barCount; i++) {
      // Sine wave + secondary harmonic for organic motion
      final primary = math.sin(elapsed * speeds[i] + phases[i]);
      final secondary = math.sin(elapsed * speeds[i] * 0.6 + phases[i] * 1.3) * 0.3;
      final sineNorm = ((primary + secondary) + 1.3) / 2.6; // 0..1

      // Mix: when live RMS is provided, scale bars to audio amplitude
      // with sine variation for organic feel
      double normalized;
      if (liveRms > 0) {
        // Scale RMS to a visible range (amplify quiet signals)
        final scaledRms = (liveRms * 8).clamp(0.0, 1.0);
        // Mix live data with sine variation for organic movement
        normalized = scaledRms * (0.5 + 0.5 * sineNorm);
      } else {
        normalized = sineNorm;
      }

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

      // When live data, use slightly brighter color
      final baseAlpha = liveRms > 0 ? alpha + 0.1 : alpha;

      final paint = Paint()
        ..color = AppColors.calmBlue.withValues(alpha: baseAlpha.clamp(0.12, 0.5));
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(_VisualizerPainter oldDelegate) =>
      elapsed != oldDelegate.elapsed || liveRms != oldDelegate.liveRms;
}
