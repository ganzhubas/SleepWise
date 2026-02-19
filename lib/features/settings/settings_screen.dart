import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/gradient_background.dart';
import 'widgets/settings_group.dart';
import 'widgets/settings_tile.dart';
import 'widgets/pro_banner.dart';
import 'widgets/segment_option.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Alarm
  String _melody = 'Восход';
  double _alarmVolume = 0.7;
  int _wakeWindow = 30;
  bool _snoozeEnabled = true;

  // Tracking
  String _micSensitivity = 'medium';
  bool _bedtimeReminder = false;
  final TimeOfDay _reminderTime = const TimeOfDay(hour: 23, minute: 0);

  // Integrations
  bool _healthConnect = false;
  bool _samsungHealth = false;

  // Appearance
  String _theme = 'dark';
  String _language = 'ru';

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      showStars: false,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.paddingM,
                AppDimensions.paddingM,
                AppDimensions.paddingM,
                0,
              ),
              child: Text(
                'Настройки',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.moonlight,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingM),

            // Scrollable settings groups
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                ),
                child: Column(
                  children: [
                    _buildAlarmGroup(),
                    const SizedBox(height: AppDimensions.paddingL),
                    _buildTrackingGroup(),
                    const SizedBox(height: AppDimensions.paddingL),
                    _buildIntegrationsGroup(),
                    const SizedBox(height: AppDimensions.paddingL),
                    _buildAppearanceGroup(),
                    const SizedBox(height: AppDimensions.paddingL),
                    _buildAccountGroup(),
                    const SizedBox(height: AppDimensions.paddingL),
                    _buildAboutGroup(),
                    const SizedBox(height: AppDimensions.paddingXXL),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildAlarmGroup() {
    return SettingsGroup(
      label: 'Будильник',
      children: [
        SettingsTile.navigation(
          icon: Icons.music_note_rounded,
          iconBgColor: AppColors.error,
          title: 'Мелодия будильника',
          value: _melody,
          onTap: () => _showMelodyPicker(),
          isFirst: true,
        ),
        SettingsTile(
          icon: Icons.volume_up_rounded,
          iconBgColor: AppColors.calmBlue,
          title: 'Громкость',
          trailing: SizedBox(
            width: 130,
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.calmBlue,
                inactiveTrackColor: AppColors.moonlight.withValues(alpha: 0.1),
                thumbColor: AppColors.calmBlue,
                overlayColor: AppColors.calmBlue.withValues(alpha: 0.1),
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              ),
              child: Slider(
                value: _alarmVolume,
                onChanged: (v) => setState(() => _alarmVolume = v),
              ),
            ),
          ),
        ),
        SettingsTile.navigation(
          icon: Icons.timelapse_rounded,
          iconBgColor: AppColors.warning,
          title: 'Окно пробуждения',
          value: '$_wakeWindow мин',
          onTap: () => _showWakeWindowPicker(),
        ),
        SettingsTile.toggle(
          icon: Icons.snooze_rounded,
          iconBgColor: AppColors.dreamPurple,
          title: 'Snooze',
          subtitle: _snoozeEnabled ? '5 мин, макс 3 раза' : null,
          value: _snoozeEnabled,
          onChanged: (v) => setState(() => _snoozeEnabled = v),
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildTrackingGroup() {
    return SettingsGroup(
      label: 'Отслеживание',
      children: [
        SettingsTile(
          icon: Icons.mic_rounded,
          iconBgColor: AppColors.success,
          title: 'Чувствительность',
          isFirst: true,
          trailing: SegmentOption<String>(
            options: const {
              'low': 'Low',
              'medium': 'Med',
              'high': 'High',
            },
            selected: _micSensitivity,
            onChanged: (v) => setState(() => _micSensitivity = v),
          ),
        ),
        SettingsTile.toggle(
          icon: Icons.bedtime_rounded,
          iconBgColor: AppColors.dreamPurple.withValues(alpha: 0.8),
          title: 'Напоминание',
          subtitle: _bedtimeReminder
              ? '${_reminderTime.hour.toString().padLeft(2, '0')}:${_reminderTime.minute.toString().padLeft(2, '0')}'
              : null,
          value: _bedtimeReminder,
          onChanged: (v) => setState(() => _bedtimeReminder = v),
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildIntegrationsGroup() {
    return SettingsGroup(
      label: 'Интеграции',
      children: [
        SettingsTile.toggle(
          icon: Icons.favorite_rounded,
          iconBgColor: const Color(0xFFFF2D55),
          title: 'Health Connect',
          subtitle: _healthConnect ? 'Подключено' : 'Не подключено',
          value: _healthConnect,
          onChanged: (v) => setState(() => _healthConnect = v),
          isFirst: true,
        ),
        SettingsTile.toggle(
          icon: Icons.watch_rounded,
          iconBgColor: const Color(0xFF1428A0),
          title: 'Samsung Health',
          subtitle: _samsungHealth ? 'Подключено' : 'Не подключено',
          value: _samsungHealth,
          onChanged: (v) => setState(() => _samsungHealth = v),
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildAppearanceGroup() {
    return SettingsGroup(
      label: 'Оформление',
      children: [
        SettingsTile(
          icon: Icons.dark_mode_rounded,
          iconBgColor: AppColors.nightSky,
          title: 'Тема',
          isFirst: true,
          trailing: SegmentOption<String>(
            options: const {
              'dark': 'Тёмная',
              'light': 'Светлая',
              'system': 'Авто',
            },
            selected: _theme,
            onChanged: (v) => setState(() => _theme = v),
          ),
        ),
        SettingsTile(
          icon: Icons.language_rounded,
          iconBgColor: AppColors.calmBlue,
          title: 'Язык',
          isLast: true,
          trailing: SegmentOption<String>(
            options: const {
              'ru': 'Рус',
              'en': 'Eng',
            },
            selected: _language,
            onChanged: (v) => setState(() => _language = v),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountGroup() {
    return SettingsGroup(
      label: 'Аккаунт',
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: ProBanner(onTap: () {}),
        ),
        SettingsTile.navigation(
          icon: Icons.restore_rounded,
          iconBgColor: AppColors.calmBlue.withValues(alpha: 0.8),
          title: 'Восстановить покупки',
          onTap: () {},
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildAboutGroup() {
    return SettingsGroup(
      label: 'О приложении',
      children: [
        SettingsTile.navigation(
          icon: Icons.shield_rounded,
          iconBgColor: AppColors.success.withValues(alpha: 0.8),
          title: 'Политика конфиденциальности',
          onTap: () {},
          isFirst: true,
        ),
        SettingsTile.navigation(
          icon: Icons.description_rounded,
          iconBgColor: AppColors.warning.withValues(alpha: 0.8),
          title: 'Условия использования',
          onTap: () {},
        ),
        SettingsTile.navigation(
          icon: Icons.star_rounded,
          iconBgColor: AppColors.starYellow,
          title: 'Оценить приложение',
          onTap: () {},
        ),
        SettingsTile(
          icon: Icons.info_outline_rounded,
          iconBgColor: AppColors.moonlight.withValues(alpha: 0.2),
          title: 'Версия',
          isLast: true,
          trailing: Text(
            '1.0.0',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.moonlight.withValues(alpha: 0.35),
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Pickers
  // ═══════════════════════════════════════════════════════════════════════════

  void _showMelodyPicker() {
    const melodies = ['Восход', 'Океан', 'Лес', 'Пианино', 'Колокольчики'];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.moonlight.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ...melodies.map((m) => ListTile(
                  leading: Icon(
                    _melody == m
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: _melody == m
                        ? AppColors.calmBlue
                        : AppColors.moonlight.withValues(alpha: 0.3),
                    size: 22,
                  ),
                  title: Text(
                    m,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      color: AppColors.moonlight.withValues(alpha: 0.8),
                    ),
                  ),
                  onTap: () {
                    setState(() => _melody = m);
                    Navigator.pop(ctx);
                  },
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showWakeWindowPicker() {
    const options = [10, 20, 30, 45, 60];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.moonlight.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ...options.map((m) => ListTile(
                  leading: Icon(
                    _wakeWindow == m
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: _wakeWindow == m
                        ? AppColors.calmBlue
                        : AppColors.moonlight.withValues(alpha: 0.3),
                    size: 22,
                  ),
                  title: Text(
                    '$m мин',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      color: AppColors.moonlight.withValues(alpha: 0.8),
                    ),
                  ),
                  onTap: () {
                    setState(() => _wakeWindow = m);
                    Navigator.pop(ctx);
                  },
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
