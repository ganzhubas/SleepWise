import 'package:flutter/material.dart';

/// Giant circular stop-alarm button (200px+) with sun icon,
/// warm white fill, soft shadow, and gentle scale pulse.
class StopAlarmButton extends StatefulWidget {
  final VoidCallback onPressed;
  final double size;

  const StopAlarmButton({
    super.key,
    required this.onPressed,
    this.size = 220,
  });

  @override
  State<StopAlarmButton> createState() => _StopAlarmButtonState();
}

class _StopAlarmButtonState extends State<StopAlarmButton>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _tapController;
  late final Animation<double> _tapScale;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _tapScale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _tapScale]),
      builder: (context, _) {
        final pulse = _pulseController.value;
        final breathe = 1.0 + pulse * 0.025;
        final scale = _tapScale.value * breathe;

        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTapDown: (_) => _tapController.forward(),
            onTapUp: (_) => _tapController.reverse(),
            onTapCancel: () => _tapController.reverse(),
            onTap: widget.onPressed,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF8C42).withValues(alpha: 0.25 + pulse * 0.15),
                    blurRadius: 40 + pulse * 20,
                    spreadRadius: 4 + pulse * 8,
                  ),
                  BoxShadow(
                    color: const Color(0xFFFFB74D).withValues(alpha: 0.15),
                    blurRadius: 60,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wb_sunny_rounded,
                      size: 64,
                      color: const Color(0xFFFF8C42).withValues(alpha: 0.9),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'СТОП',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3D2E1C),
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
