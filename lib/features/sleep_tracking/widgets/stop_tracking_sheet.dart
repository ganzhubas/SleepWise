import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_colors.dart';

/// Bottom sheet confirmation dialog for stopping sleep tracking.
class StopTrackingSheet extends StatelessWidget {
  final VoidCallback onStop;
  final VoidCallback onContinue;

  const StopTrackingSheet({
    super.key,
    required this.onStop,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(
            color: AppColors.moonlight.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingL,
            vertical: AppDimensions.paddingM,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.moonlight.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXL),

              // Title
              Text(
                'Остановить отслеживание?',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.moonlight.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingS),
              Text(
                'Данные сна будут сохранены',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: AppColors.moonlight.withValues(alpha: 0.3),
                ),
              ),

              const SizedBox(height: AppDimensions.paddingXL),

              // Stop button (red)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: onStop,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error.withValues(alpha: 0.15),
                    foregroundColor: AppColors.error,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Остановить',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.paddingM),

              // Continue button (outline)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: onContinue,
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        AppColors.moonlight.withValues(alpha: 0.5),
                    side: BorderSide(
                      color: AppColors.moonlight.withValues(alpha: 0.12),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusM),
                    ),
                  ),
                  child: const Text(
                    'Продолжить',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.paddingS),
            ],
          ),
        ),
      ),
    );
  }
}
