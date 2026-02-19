import 'package:flutter/material.dart';

/// Fade + scale transition for onboarding → main screen.
class FadeScaleRoute<T> extends PageRouteBuilder<T> {
  FadeScaleRoute({required Widget page})
      : super(
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.92, end: 1.0).animate(curved),
                child: child,
              ),
            );
          },
        );
}

/// Slow fade-to-black for alarm → night mode.
class FadeToBlackRoute<T> extends PageRouteBuilder<T> {
  FadeToBlackRoute({required Widget page})
      : super(
          transitionDuration: const Duration(milliseconds: 800),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Stack(
              children: [
                FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
                    ),
                  ),
                  child: Container(color: Colors.black),
                ),
                FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
                    ),
                  ),
                  child: child,
                ),
              ],
            );
          },
        );
}

/// Dawn gradient for wake-up → morning report (or night → wake-up).
class DawnRoute<T> extends PageRouteBuilder<T> {
  DawnRoute({required Widget page})
      : super(
          transitionDuration: const Duration(milliseconds: 1500),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Stack(
              children: [
                AnimatedBuilder(
                  animation: animation,
                  builder: (context, _) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.lerp(
                              const Color(0xFF0D1B2A),
                              const Color(0xFF1A0E2E),
                              animation.value,
                            )!,
                            Color.lerp(
                              const Color(0xFF0D1B2A),
                              const Color(0xFFF4845F),
                              (animation.value * 0.7).clamp(0.0, 1.0),
                            )!,
                            Color.lerp(
                              const Color(0xFF0D1B2A),
                              const Color(0xFFFFD166),
                              (animation.value * 0.5).clamp(0.0, 1.0),
                            )!,
                          ],
                        ),
                      ),
                    );
                  },
                ),
                FadeTransition(
                  opacity: CurvedAnimation(
                    parent: animation,
                    curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                  ),
                  child: child,
                ),
              ],
            );
          },
        );
}

/// Slide up from bottom for wake-up → morning report.
class SlideUpRoute<T> extends PageRouteBuilder<T> {
  SlideUpRoute({required Widget page})
      : super(
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.25),
                end: Offset.zero,
              ).animate(curved),
              child: FadeTransition(
                opacity: curved,
                child: child,
              ),
            );
          },
        );
}
