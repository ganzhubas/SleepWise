import 'package:flutter/material.dart';

/// Horizontal swipe-to-stop slider: user drags thumb to the right edge
/// to dismiss the alarm. Springs back if released before threshold.
class SwipeToStop extends StatefulWidget {
  final VoidCallback onStopped;

  const SwipeToStop({super.key, required this.onStopped});

  @override
  State<SwipeToStop> createState() => _SwipeToStopState();
}

class _SwipeToStopState extends State<SwipeToStop>
    with SingleTickerProviderStateMixin {
  double _dragX = 0;
  double _maxDrag = 0;
  late final AnimationController _resetController;

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        setState(() => _dragX = _dragX * (1 - _resetController.value));
      });
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final trackW = constraints.maxWidth;
      const thumbSize = 60.0;
      _maxDrag = trackW - thumbSize - 8; // 8 for padding

      final progress = (_dragX / _maxDrag).clamp(0.0, 1.0);

      return Container(
        height: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34),
          color: Colors.white.withValues(alpha: 0.12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Label — fades out as dragged
            Center(
              child: Opacity(
                opacity: (1 - progress * 2).clamp(0.0, 1.0),
                child: const Text(
                  'Сдвиньте, чтобы остановить',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Colors.white54,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            // Draggable thumb
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: GestureDetector(
                onHorizontalDragUpdate: (d) {
                  setState(() {
                    _dragX = (_dragX + d.delta.dx).clamp(0.0, _maxDrag);
                  });
                },
                onHorizontalDragEnd: (_) {
                  if (progress > 0.85) {
                    widget.onStopped();
                  } else {
                    _resetController.forward(from: 0);
                  }
                },
                child: Transform.translate(
                  offset: Offset(_dragX, 0),
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF8C42).withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.wb_sunny_rounded,
                      color: Color(0xFFFF8C42),
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
