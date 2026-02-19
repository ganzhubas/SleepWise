import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Animated mini equalizer (3-5 bars) shown next to the playing melody.
class MiniEqualizer extends StatefulWidget {
  final bool playing;
  final int barCount;
  final double width;
  final double height;
  final Color? color;

  const MiniEqualizer({
    super.key,
    required this.playing,
    this.barCount = 4,
    this.width = 20,
    this.height = 18,
    this.color,
  });

  @override
  State<MiniEqualizer> createState() => _MiniEqualizerState();
}

class _MiniEqualizerState extends State<MiniEqualizer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    if (widget.playing) _controller.repeat();
  }

  @override
  void didUpdateWidget(MiniEqualizer old) {
    super.didUpdateWidget(old);
    if (widget.playing && !old.playing) {
      _controller.repeat();
    } else if (!widget.playing && old.playing) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.playing) return SizedBox(width: widget.width, height: widget.height);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: _EqualizerPainter(
            progress: _controller.value,
            barCount: widget.barCount,
            color: widget.color ?? AppColors.calmBlue,
          ),
        );
      },
    );
  }
}

class _EqualizerPainter extends CustomPainter {
  final double progress;
  final int barCount;
  final Color color;

  _EqualizerPainter({
    required this.progress,
    required this.barCount,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barW = size.width / (barCount * 2 - 1);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (var i = 0; i < barCount; i++) {
      // Each bar has its own phase offset for organic movement
      final phase = i * 0.7 + 0.3;
      final t = (progress * 2 * math.pi + phase);
      // Height oscillates between 25% and 100%
      final fraction = 0.25 + 0.75 * ((math.sin(t) + 1) / 2);
      final barH = size.height * fraction;
      final x = i * barW * 2;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, size.height - barH, barW, barH),
          Radius.circular(barW / 2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_EqualizerPainter old) => progress != old.progress;
}
