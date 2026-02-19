import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/theme/app_colors.dart';

/// Large circular START button with gradient, glow, and pulse animation.
class StartButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final double size;

  const StartButton({
    super.key,
    this.onPressed,
    this.size = 180,
  });

  @override
  State<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _tapController;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _tapController = AnimationController(
      vsync: this,
      duration: AppDurations.fast,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
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
      animation: Listenable.merge([_pulseAnimation, _scaleAnimation]),
      builder: (context, _) {
        final pulse = _pulseAnimation.value;
        final scale = _scaleAnimation.value;

        return Transform.scale(
          scale: scale,
          child: SizedBox(
            width: widget.size + 40,
            height: widget.size + 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer pulsing glow ring
                Container(
                  width: widget.size + 20 + pulse * 16,
                  height: widget.size + 20 + pulse * 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.calmBlue
                            .withValues(alpha: 0.12 + pulse * 0.08),
                        blurRadius: 30 + pulse * 15,
                        spreadRadius: 2 + pulse * 4,
                      ),
                      BoxShadow(
                        color: AppColors.dreamPurple
                            .withValues(alpha: 0.08 + pulse * 0.05),
                        blurRadius: 50 + pulse * 20,
                        spreadRadius: 4 + pulse * 6,
                      ),
                    ],
                  ),
                ),

                // Gradient border ring
                Container(
                  width: widget.size + 8,
                  height: widget.size + 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      startAngle: 0,
                      endAngle: math.pi * 2,
                      colors: [
                        AppColors.calmBlue.withValues(alpha: 0.4),
                        AppColors.dreamPurple.withValues(alpha: 0.2),
                        AppColors.calmBlue.withValues(alpha: 0.1),
                        AppColors.dreamPurple.withValues(alpha: 0.3),
                        AppColors.calmBlue.withValues(alpha: 0.4),
                      ],
                    ),
                  ),
                ),

                // Main button body
                GestureDetector(
                  onTapDown:
                      widget.onPressed != null ? (_) => _tapController.forward() : null,
                  onTapUp: widget.onPressed != null
                      ? (_) => _tapController.reverse()
                      : null,
                  onTapCancel: widget.onPressed != null
                      ? () => _tapController.reverse()
                      : null,
                  onTap: widget.onPressed,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.calmBlue, AppColors.dreamPurple],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.calmBlue.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                        BoxShadow(
                          color: AppColors.dreamPurple.withValues(alpha: 0.3),
                          blurRadius: 35,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bedtime_rounded,
                            color: Colors.white.withValues(alpha: 0.9),
                            size: AppDimensions.iconXL,
                          ),
                          const SizedBox(height: AppDimensions.paddingS),
                          Text(
                            'СТАРТ',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 3,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
