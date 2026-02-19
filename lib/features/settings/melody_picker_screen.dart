import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/gradient_background.dart';
import '../paywall/paywall_screen.dart';
import 'widgets/mini_equalizer.dart';

/// Data for a single alarm melody option.
class _MelodyOption {
  final String id;
  final IconData icon;
  final String title;
  final String subtitle;

  const _MelodyOption({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

const _melodies = <_MelodyOption>[
  _MelodyOption(
    id: 'sunrise_glow',
    icon: Icons.wb_twilight_rounded,
    title: 'Sunrise Glow',
    subtitle: 'Мягкие колокольчики',
  ),
  _MelodyOption(
    id: 'forest_morning',
    icon: Icons.forest_rounded,
    title: 'Forest Morning',
    subtitle: 'Пение птиц',
  ),
  _MelodyOption(
    id: 'ocean_breeze',
    icon: Icons.waves_rounded,
    title: 'Ocean Breeze',
    subtitle: 'Волны',
  ),
  _MelodyOption(
    id: 'gentle_piano',
    icon: Icons.piano_rounded,
    title: 'Gentle Piano',
    subtitle: 'Фортепиано',
  ),
  _MelodyOption(
    id: 'digital_soft',
    icon: Icons.graphic_eq_rounded,
    title: 'Digital Soft',
    subtitle: 'Электронная',
  ),
  _MelodyOption(
    id: 'classic_bell',
    icon: Icons.notifications_active_rounded,
    title: 'Classic Bell',
    subtitle: 'Классический звонок',
  ),
  _MelodyOption(
    id: 'rain_to_sun',
    icon: Icons.thunderstorm_rounded,
    title: 'Rain to Sun',
    subtitle: 'Дождь переходит в мелодию',
  ),
  _MelodyOption(
    id: 'zen_garden',
    icon: Icons.self_improvement_rounded,
    title: 'Zen Garden',
    subtitle: 'Тибетские чаши',
  ),
  _MelodyOption(
    id: 'vibration_only',
    icon: Icons.vibration_rounded,
    title: 'Только вибрация',
    subtitle: 'Без звука',
  ),
];

/// Melody picker screen navigated from settings.
class MelodyPickerScreen extends StatefulWidget {
  final String selectedId;
  final ValueChanged<String>? onSelected;

  const MelodyPickerScreen({
    super.key,
    this.selectedId = 'sunrise_glow',
    this.onSelected,
  });

  @override
  State<MelodyPickerScreen> createState() => _MelodyPickerScreenState();
}

class _MelodyPickerScreenState extends State<MelodyPickerScreen>
    with SingleTickerProviderStateMixin {
  late String _selected;
  String? _playingId;
  Timer? _previewTimer;

  late final AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedId;
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _previewTimer?.cancel();
    _staggerController.dispose();
    super.dispose();
  }

  void _onTapMelody(String id) {
    // Stop previous preview
    _previewTimer?.cancel();

    setState(() {
      _selected = id;
      _playingId = id;
    });

    widget.onSelected?.call(id);

    // Play system click as preview stub
    try {
      HapticFeedback.lightImpact();
    } catch (_) {}

    // Stop preview after 5 seconds
    _previewTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) setState(() => _playingId = null);
    });
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
    final totalItems = _melodies.length + 1; // +1 for custom melody

    return GradientBackground(
      showStars: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.moonlight.withValues(alpha: 0.7),
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Мелодия будильника',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.moonlight,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.paddingS,
            ),
            itemCount: _melodies.length + 1, // +1 for custom melody
            itemBuilder: (context, index) {
              if (index < _melodies.length) {
                return _buildMelodyTile(_melodies[index], index, totalItems);
              }
              return _buildCustomMelodyTile(index, totalItems);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMelodyTile(_MelodyOption melody, int index, int total) {
    final isSelected = melody.id == _selected;
    final isPlaying = melody.id == _playingId;

    final anim = _stagger(index, total);

    return AnimatedBuilder(
      animation: anim,
      builder: (context, _) {
        return Opacity(
          opacity: anim.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - anim.value)),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _onTapMelody(melody.id),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  splashColor: AppColors.calmBlue.withValues(alpha: 0.08),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.calmBlue.withValues(alpha: 0.08)
                          : AppColors.darkSurface.withValues(alpha: 0.5),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusM),
                      border: isSelected
                          ? Border.all(
                              color:
                                  AppColors.calmBlue.withValues(alpha: 0.25),
                              width: 1)
                          : null,
                    ),
                    child: Row(
                      children: [
                        // Icon
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.calmBlue.withValues(alpha: 0.15)
                                : AppColors.moonlight.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            melody.icon,
                            size: 22,
                            color: isSelected
                                ? AppColors.calmBlue
                                : AppColors.moonlight.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Title + subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                melody.title,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 15,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.moonlight
                                      : AppColors.moonlight
                                          .withValues(alpha: 0.8),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                melody.subtitle,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: AppColors.moonlight
                                      .withValues(alpha: 0.35),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Equalizer or spacer
                        if (isPlaying)
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: MiniEqualizer(
                              playing: true,
                              barCount: 4,
                              width: 22,
                              height: 18,
                              color: AppColors.calmBlue,
                            ),
                          )
                        else
                          const SizedBox(width: 32),
                        // Radio button
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.calmBlue
                                  : AppColors.moonlight
                                      .withValues(alpha: 0.2),
                              width: isSelected ? 2 : 1.5,
                            ),
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 10,
                                    height: 10,
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
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomMelodyTile(int index, int total) {
    final anim = _stagger(index, total);

    return AnimatedBuilder(
      animation: anim,
      builder: (context, _) {
        return Opacity(
          opacity: anim.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - anim.value)),
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const PaywallScreen()),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface.withValues(alpha: 0.5),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.moonlight.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.library_music_rounded,
                        size: 22,
                        color:
                            AppColors.moonlight.withValues(alpha: 0.35),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Title + subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Своя мелодия',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.moonlight
                                  .withValues(alpha: 0.45),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Выберите из медиатеки',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: AppColors.moonlight
                                  .withValues(alpha: 0.25),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Lock icon + Pro badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            AppColors.starYellow.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock_rounded,
                            size: 12,
                            color: AppColors.starYellow
                                .withValues(alpha: 0.8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'PRO',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.starYellow,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ),
            ),
          ),
        );
      },
    );
  }
}
