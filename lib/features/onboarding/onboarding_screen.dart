import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/sleep_button.dart';
import 'permissions_screen.dart';
import 'widgets/chart_illustration.dart';
import 'widgets/moon_illustration.dart';
import 'widgets/page_indicator.dart';
import 'widgets/phone_illustration.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _prefKey = 'onboarding_completed';

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, true);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PermissionsScreen()),
      );
    }
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.centerRight,
                child: AnimatedOpacity(
                  opacity: _currentPage < 3 ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: AppDimensions.paddingS,
                      right: AppDimensions.paddingM,
                    ),
                    child: GestureDetector(
                      onTap: _currentPage < 3 ? _completeOnboarding : null,
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimensions.paddingS),
                        child: Text(
                          'Пропустить',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.moonlight.withValues(alpha: 0.5),
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // PageView
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) => setState(() => _currentPage = page),
                  children: [
                    _buildPage1(context),
                    _buildPage2(context),
                    _buildPage3(context),
                    _buildPage4(context),
                  ],
                ),
              ),

              // Bottom section: indicator + next button
              Padding(
                padding: const EdgeInsets.only(
                  left: AppDimensions.paddingL,
                  right: AppDimensions.paddingL,
                  bottom: AppDimensions.paddingXL,
                ),
                child: _currentPage < 3
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PageIndicator(
                            pageCount: 4,
                            currentPage: _currentPage,
                          ),
                          _NextButton(onTap: _nextPage),
                        ],
                      )
                    : PageIndicator(
                        pageCount: 4,
                        currentPage: _currentPage,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage1(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const MoonIllustration(size: 240),
          const SizedBox(height: AppDimensions.paddingXXL),
          Text(
            'Просыпайтесь легко',
            style: theme.textTheme.displayMedium?.copyWith(
              color: AppColors.moonlight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            'SleepWise анализирует ваш сон\nи будит в идеальный момент',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.moonlight.withValues(alpha: 0.6),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPage2(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const PhoneIllustration(size: 240),
          const SizedBox(height: AppDimensions.paddingXXL),
          Text(
            'Просто положите\nтелефон рядом',
            style: theme.textTheme.displayMedium?.copyWith(
              color: AppColors.moonlight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            'Микрофон определит фазы сна\nпо звукам движения',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.moonlight.withValues(alpha: 0.6),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPage3(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ChartIllustration(size: 240),
          const SizedBox(height: AppDimensions.paddingXXL),
          Text(
            'Ваш сон в деталях',
            style: theme.textTheme.displayMedium?.copyWith(
              color: AppColors.moonlight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            'Понятные графики и оценка\nкаждое утро',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.moonlight.withValues(alpha: 0.6),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPage4(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon hero
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.calmBlue.withValues(alpha: 0.15),
                  AppColors.dreamPurple.withValues(alpha: 0.05),
                  Colors.transparent,
                ],
              ),
            ),
            child: Icon(
              Icons.nights_stay_rounded,
              size: 72,
              color: AppColors.starYellow.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXXL),
          Text(
            'Всё готово!',
            style: theme.textTheme.displayMedium?.copyWith(
              color: AppColors.moonlight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            'Настройте будильник и ложитесь\nспать спокойно',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.moonlight.withValues(alpha: 0.6),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingXXL),
          SleepButton(
            label: 'Начать',
            onPressed: _completeOnboarding,
            variant: SleepButtonVariant.primary,
            width: double.infinity,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            'Приложение попросит доступ к микрофону\nи уведомлениям',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.moonlight.withValues(alpha: 0.35),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  final VoidCallback onTap;

  const _NextButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [AppColors.calmBlue, AppColors.dreamPurple],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.calmBlue.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_forward_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
