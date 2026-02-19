import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../l10n/app_localizations.dart';

/// SleepWise Pro upgrade banner with gradient background and feature list.
class ProBanner extends StatelessWidget {
  final VoidCallback? onTap;

  const ProBanner({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final features = [
      l.proBannerFeature1,
      l.proBannerFeature2,
      l.proBannerFeature3,
      l.proBannerFeature4,
      l.proBannerFeature5,
    ];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.calmBlue.withValues(alpha: 0.25),
              AppColors.dreamPurple.withValues(alpha: 0.20),
            ],
          ),
          border: Border.all(
            color: AppColors.calmBlue.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.starYellow.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'PRO',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.starYellow,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'SleepWise Pro',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.moonlight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Feature list
            ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: AppColors.success.withValues(alpha: 0.8),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          f,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color:
                                AppColors.moonlight.withValues(alpha: 0.65),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 8),
            // CTA button
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.calmBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  l.tryFreeBanner,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
