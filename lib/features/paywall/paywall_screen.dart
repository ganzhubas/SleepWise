import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_colors.dart';

/// Full-screen paywall for SleepWise Pro subscription.
class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _staggerController;
  int _selectedPlan = 1; // 0 = monthly, 1 = yearly

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  Animation<double> _stagger(int index, int total) {
    final start = (index / total) * 0.5;
    final end = start + 0.5;
    return CurvedAnimation(
      parent: _staggerController,
      curve: Interval(
        start.clamp(0, 1),
        end.clamp(0, 1),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const totalItems = 12;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A1628),
              AppColors.nightSky,
              AppColors.primaryDark,
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: AppDimensions.paddingS,
                    top: AppDimensions.paddingXS,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: AppColors.moonlight.withValues(alpha: 0.4),
                      size: 26,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingL,
                  ),
                  child: Column(
                    children: [
                      // PRO badge with glow
                      _StaggeredItem(
                        animation: _stagger(0, totalItems),
                        child: const _ProBadgeGlow(),
                      ),

                      const SizedBox(height: 20),

                      // Title
                      _StaggeredItem(
                        animation: _stagger(1, totalItems),
                        child: Text(
                          'Раскройте весь\nпотенциал сна',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.moonlight,
                            height: 1.2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      _StaggeredItem(
                        animation: _stagger(1, totalItems),
                        child: Text(
                          'Всё для идеального сна в одном месте',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: AppColors.moonlight.withValues(alpha: 0.4),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Features list
                      ..._features.asMap().entries.map((e) {
                        return _StaggeredItem(
                          animation: _stagger(2 + e.key, totalItems),
                          child: _FeatureRow(
                            icon: e.value.icon,
                            text: e.value.text,
                          ),
                        );
                      }),

                      const SizedBox(height: 32),

                      // Plan cards
                      _StaggeredItem(
                        animation: _stagger(9, totalItems),
                        child: Row(
                          children: [
                            Expanded(
                              child: _PlanCard(
                                title: 'Месячная',
                                price: '99 ₽/мес',
                                isSelected: _selectedPlan == 0,
                                onTap: () =>
                                    setState(() => _selectedPlan = 0),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _PlanCard(
                                title: 'Годовая',
                                price: '649 ₽/год',
                                badge: '−45%',
                                isSelected: _selectedPlan == 1,
                                isBestValue: true,
                                onTap: () =>
                                    setState(() => _selectedPlan = 1),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // CTA button
                      _StaggeredItem(
                        animation: _stagger(10, totalItems),
                        child: const _CtaButton(),
                      ),

                      const SizedBox(height: 12),

                      // Fine print
                      _StaggeredItem(
                        animation: _stagger(11, totalItems),
                        child: Text(
                          _selectedPlan == 1
                              ? 'Затем 649 ₽/год. Отмена в любое время.'
                              : 'Затем 99 ₽/мес. Отмена в любое время.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: AppColors.moonlight.withValues(alpha: 0.25),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Restore purchases
                      _StaggeredItem(
                        animation: _stagger(11, totalItems),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Восстановить покупки',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color:
                                  AppColors.moonlight.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppDimensions.paddingL),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Features data
// ═════════════════════════════════════════════════════════════════════════════

class _Feature {
  final IconData icon;
  final String text;
  const _Feature(this.icon, this.text);
}

const _features = <_Feature>[
  _Feature(Icons.history_rounded, 'Полная история сна без ограничений'),
  _Feature(Icons.insights_rounded, 'Расширенная аналитика и тренды'),
  _Feature(Icons.calendar_month_rounded, 'Расписание по дням недели'),
  _Feature(Icons.mic_rounded, 'Детальный анализ храпа'),
  _Feature(Icons.music_note_rounded, 'Дополнительные мелодии'),
  _Feature(Icons.upload_file_rounded, 'Экспорт данных'),
  _Feature(Icons.block_rounded, 'Без рекламы'),
];

// ═════════════════════════════════════════════════════════════════════════════
// PRO badge with glow effect
// ═════════════════════════════════════════════════════════════════════════════

class _ProBadgeGlow extends StatefulWidget {
  const _ProBadgeGlow();

  @override
  State<_ProBadgeGlow> createState() => _ProBadgeGlowState();
}

class _ProBadgeGlowState extends State<_ProBadgeGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        final glow = 0.3 + 0.4 * _glowController.value;
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.calmBlue.withValues(alpha: 0.2),
                AppColors.dreamPurple.withValues(alpha: 0.15),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.calmBlue.withValues(alpha: glow * 0.3),
                blurRadius: 30 + 15 * glow,
                spreadRadius: 5 * glow,
              ),
              BoxShadow(
                color: AppColors.dreamPurple.withValues(alpha: glow * 0.15),
                blurRadius: 40 + 20 * glow,
                spreadRadius: 8 * glow,
              ),
            ],
          ),
          child: Center(
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.calmBlue,
                  AppColors.dreamPurple,
                  AppColors.calmBlue,
                ],
                stops: [
                  0.0,
                  0.5 + 0.2 * math.sin(_glowController.value * math.pi),
                  1.0,
                ],
              ).createShader(bounds),
              child: const Text(
                'PRO',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 3,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Feature row
// ═════════════════════════════════════════════════════════════════════════════

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.check_rounded,
              size: 18,
              color: AppColors.success,
            ),
          ),
          const SizedBox(width: 14),
          Icon(
            icon,
            size: 18,
            color: AppColors.moonlight.withValues(alpha: 0.4),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.moonlight.withValues(alpha: 0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Plan card
// ═════════════════════════════════════════════════════════════════════════════

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String? badge;
  final bool isSelected;
  final bool isBestValue;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    this.badge,
    required this.isSelected,
    this.isBestValue = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.calmBlue.withValues(alpha: 0.1)
              : AppColors.darkSurface.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: isSelected
                ? AppColors.calmBlue.withValues(alpha: 0.5)
                : AppColors.moonlight.withValues(alpha: 0.08),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            // Badge
            if (badge != null)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
              )
            else
              const SizedBox(height: 23),
            // Title
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.moonlight
                    : AppColors.moonlight.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 4),
            // Price
            Text(
              price,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? AppColors.calmBlue
                    : AppColors.moonlight.withValues(alpha: 0.35),
              ),
            ),
            const SizedBox(height: 6),
            // Radio indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.calmBlue
                      : AppColors.moonlight.withValues(alpha: 0.2),
                  width: isSelected ? 2 : 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.calmBlue,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// CTA button with glow
// ═════════════════════════════════════════════════════════════════════════════

class _CtaButton extends StatefulWidget {
  const _CtaButton();

  @override
  State<_CtaButton> createState() => _CtaButtonState();
}

class _CtaButtonState extends State<_CtaButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, _) {
        final glow = 0.15 + 0.15 * _pulseController.value;
        return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            boxShadow: [
              BoxShadow(
                color: AppColors.calmBlue.withValues(alpha: glow),
                blurRadius: 20 + 10 * _pulseController.value,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.calmBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusL),
              ),
              elevation: 0,
              padding: EdgeInsets.zero,
            ),
            child: const Text(
              'Попробовать 7 дней бесплатно',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Staggered animation wrapper
// ═════════════════════════════════════════════════════════════════════════════

class _StaggeredItem extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _StaggeredItem({required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - animation.value)),
            child: child,
          ),
        );
      },
    );
  }
}
