import 'dart:io';

import 'package:flutter/material.dart';
import '../../app/sleepwise_app.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/settings_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../services/health_service.dart';
import '../../services/notification_service.dart';
import '../../widgets/gradient_background.dart';
import 'widgets/settings_group.dart';
import 'widgets/settings_tile.dart';
import 'widgets/pro_banner.dart';
import 'widgets/segment_option.dart';
import 'melody_picker_screen.dart';
import '../paywall/paywall_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Alarm
  String _melodyId = 'sunrise_glow';
  static const _melodyNames = {
    'sunrise_glow': 'Sunrise Glow',
    'forest_morning': 'Forest Morning',
    'ocean_breeze': 'Ocean Breeze',
    'gentle_piano': 'Gentle Piano',
    'digital_soft': 'Digital Soft',
    'classic_bell': 'Classic Bell',
    'rain_to_sun': 'Rain to Sun',
    'zen_garden': 'Zen Garden',
  };
  double _alarmVolume = 0.7;
  int _wakeWindow = 30;
  bool _snoozeEnabled = true;

  // Tracking
  String _micSensitivity = 'medium';
  bool _bedtimeReminder = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 23, minute: 0);

  // Integrations
  bool _healthSync = false;
  String? _healthStatusKey;
  bool _healthLoading = false;
  bool _samsungHealth = false;
  String? _samsungStatusKey;
  bool _samsungLoading = false;

  // Appearance
  String _theme = 'dark';
  String _language = 'ru';

  final _settingsRepo = SettingsRepository();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await _settingsRepo.getSettings();
      if (!mounted) return;

      // Restore bedtime reminder state
      if (settings.bedtimeReminder) {
        setState(() {
          _bedtimeReminder = true;
          _reminderTime = TimeOfDay(
            hour: settings.reminderHour,
            minute: settings.reminderMinute,
          );
        });
      }

      // Restore language
      if (settings.language.isNotEmpty) {
        setState(() => _language = settings.language);
      }

      if (settings.healthConnect) {
        final hasPerms = await HealthService.instance.hasPermissions();
        if (mounted) {
          setState(() {
            _healthSync = hasPerms;
            _healthStatusKey = hasPerms ? 'connected' : 'noPermission';
          });
        }
      }
      if (settings.samsungHealth) {
        setState(() {
          _samsungHealth = true;
          _samsungStatusKey = 'viaConnect';
        });
      }
    } catch (_) {
      // Settings not available yet
    }
  }

  String _healthStatusText(L l) {
    if (_healthLoading) return l.healthConnecting;
    switch (_healthStatusKey) {
      case 'connected':
        return l.healthConnected;
      case 'noPermission':
        return l.healthNoPermission;
      case 'denied':
        return l.healthDenied;
      case 'unavailable':
        return l.healthUnavailable;
      default:
        return l.healthNotConnected;
    }
  }

  String _samsungStatusText(L l) {
    if (_samsungLoading) return l.healthConnecting;
    switch (_samsungStatusKey) {
      case 'viaConnect':
        return l.healthViaConnect;
      case 'failed':
        return l.healthFailed;
      case 'notFound':
        return l.healthConnectNotFound;
      default:
        return l.healthNotConnected;
    }
  }

  Future<void> _toggleHealthSync(bool enable) async {
    final l = L.of(context);
    if (enable) {
      setState(() => _healthLoading = true);
      final status = await HealthService.instance.requestPermissions();
      if (!mounted) return;

      switch (status) {
        case HealthConnectionStatus.connected:
          setState(() {
            _healthSync = true;
            _healthStatusKey = 'connected';
            _healthLoading = false;
          });
          await _settingsRepo.updateSettings(
            (s) => s.copyWith(healthConnect: true),
          );
        case HealthConnectionStatus.denied:
          setState(() {
            _healthSync = false;
            _healthStatusKey = 'denied';
            _healthLoading = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l.healthPermSnackbar(HealthService.instance.platformName),
                  style: const TextStyle(fontFamily: 'Inter'),
                ),
                backgroundColor: AppColors.darkSurface,
              ),
            );
          }
        case HealthConnectionStatus.unavailable:
          setState(() {
            _healthSync = false;
            _healthStatusKey = 'unavailable';
            _healthLoading = false;
          });
          if (mounted) _showHealthUnavailableDialog();
      }
    } else {
      setState(() {
        _healthSync = false;
        _healthStatusKey = null;
      });
      await _settingsRepo.updateSettings(
        (s) => s.copyWith(healthConnect: false),
      );
    }
  }

  Future<void> _toggleSamsungHealth(bool enable) async {
    if (enable) {
      setState(() => _samsungLoading = true);

      final available = await HealthService.instance.isHealthConnectAvailable();
      if (!mounted) return;

      if (available) {
        final status = await HealthService.instance.requestPermissions();
        if (!mounted) return;
        if (status == HealthConnectionStatus.connected) {
          setState(() {
            _samsungHealth = true;
            _samsungStatusKey = 'viaConnect';
            _samsungLoading = false;
          });
          await _settingsRepo.updateSettings(
            (s) => s.copyWith(samsungHealth: true),
          );
        } else {
          setState(() {
            _samsungHealth = false;
            _samsungStatusKey = 'failed';
            _samsungLoading = false;
          });
        }
      } else {
        setState(() {
          _samsungHealth = false;
          _samsungStatusKey = 'notFound';
          _samsungLoading = false;
        });
        if (mounted) _showSamsungFallbackDialog();
      }
    } else {
      setState(() {
        _samsungHealth = false;
        _samsungStatusKey = null;
      });
      await _settingsRepo.updateSettings(
        (s) => s.copyWith(samsungHealth: false),
      );
    }
  }

  Future<void> _toggleBedtimeReminder(bool enable) async {
    if (enable) {
      final picked = await showTimePicker(
        context: context,
        initialTime: _reminderTime,
        builder: (ctx, child) => Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.calmBlue,
              surface: AppColors.darkSurface,
            ),
          ),
          child: child!,
        ),
      );
      if (picked == null || !mounted) return;

      setState(() {
        _bedtimeReminder = true;
        _reminderTime = picked;
      });

      await NotificationService.instance.scheduleBedtimeReminder(
        hour: picked.hour,
        minute: picked.minute,
      );
      await _settingsRepo.updateSettings(
        (s) => s.copyWith(
          bedtimeReminder: true,
          reminderHour: picked.hour,
          reminderMinute: picked.minute,
        ),
      );
    } else {
      setState(() => _bedtimeReminder = false);
      await NotificationService.instance.cancelBedtimeReminder();
      await _settingsRepo.updateSettings(
        (s) => s.copyWith(bedtimeReminder: false),
      );
    }
  }

  void _onLanguageChanged(String lang) {
    setState(() => _language = lang);
    // Update global locale
    localeNotifier.value = Locale(lang);
    _settingsRepo.updateSettings(
      (s) => s.copyWith(language: lang),
    );
  }

  void _showHealthUnavailableDialog() {
    final l = L.of(context);
    final name = Platform.isIOS ? 'Apple Health' : 'Health Connect';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: Text(
          l.healthUnavailableTitle(name),
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: AppColors.moonlight,
          ),
        ),
        content: Text(
          Platform.isAndroid ? l.healthConnectInstall : l.healthAppleCheck,
          style: TextStyle(
            fontFamily: 'Inter',
            color: AppColors.moonlight.withValues(alpha: 0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l.understood,
              style: TextStyle(color: AppColors.calmBlue),
            ),
          ),
        ],
      ),
    );
  }

  void _showSamsungFallbackDialog() {
    final l = L.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: Text(
          l.samsungHealthTitle,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: AppColors.moonlight,
          ),
        ),
        content: Text(
          l.samsungHealthInstructions,
          style: TextStyle(
            fontFamily: 'Inter',
            height: 1.5,
            color: AppColors.moonlight.withValues(alpha: 0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l.understood,
              style: TextStyle(color: AppColors.calmBlue),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
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
                l.settings,
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
                    _buildAlarmGroup(l),
                    const SizedBox(height: AppDimensions.paddingL),
                    _buildTrackingGroup(l),
                    const SizedBox(height: AppDimensions.paddingL),
                    _buildIntegrationsGroup(l),
                    const SizedBox(height: AppDimensions.paddingL),
                    _buildAppearanceGroup(l),
                    const SizedBox(height: AppDimensions.paddingL),
                    _buildAccountGroup(l),
                    const SizedBox(height: AppDimensions.paddingL),
                    _buildAboutGroup(l),
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

  String _melodyDisplayName(L l) {
    if (_melodyId == 'vibration_only') return l.melodyVibration;
    return _melodyNames[_melodyId] ?? _melodyId;
  }

  Widget _buildAlarmGroup(L l) {
    return SettingsGroup(
      label: l.settingsAlarm,
      children: [
        SettingsTile.navigation(
          icon: Icons.music_note_rounded,
          iconBgColor: AppColors.error,
          title: l.settingsMelody,
          value: _melodyDisplayName(l),
          onTap: () => _openMelodyPicker(),
          isFirst: true,
        ),
        SettingsTile(
          icon: Icons.volume_up_rounded,
          iconBgColor: AppColors.calmBlue,
          title: l.settingsVolume,
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
          title: l.settingsWakeWindow,
          value: l.minutesShort(_wakeWindow),
          onTap: () => _showWakeWindowPicker(),
        ),
        SettingsTile.toggle(
          icon: Icons.snooze_rounded,
          iconBgColor: AppColors.dreamPurple,
          title: l.settingsSnooze,
          subtitle: _snoozeEnabled ? l.settingsSnoozeDesc : null,
          value: _snoozeEnabled,
          onChanged: (v) => setState(() => _snoozeEnabled = v),
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildTrackingGroup(L l) {
    return SettingsGroup(
      label: l.settingsTracking,
      children: [
        SettingsTile(
          icon: Icons.mic_rounded,
          iconBgColor: AppColors.success,
          title: l.settingsSensitivity,
          isFirst: true,
          trailing: SegmentOption<String>(
            options: {
              'low': l.sensitivityLow,
              'medium': l.sensitivityMed,
              'high': l.sensitivityHigh,
            },
            selected: _micSensitivity,
            onChanged: (v) => setState(() => _micSensitivity = v),
          ),
        ),
        SettingsTile.toggle(
          icon: Icons.bedtime_rounded,
          iconBgColor: AppColors.dreamPurple.withValues(alpha: 0.8),
          title: l.settingsReminder,
          subtitle: _bedtimeReminder
              ? '${_reminderTime.hour.toString().padLeft(2, '0')}:${_reminderTime.minute.toString().padLeft(2, '0')}'
              : null,
          value: _bedtimeReminder,
          onChanged: (v) => _toggleBedtimeReminder(v),
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildIntegrationsGroup(L l) {
    final isIOS = Platform.isIOS;
    final healthTitle = isIOS ? 'Apple Health' : 'Health Connect';
    final healthIcon = isIOS ? Icons.favorite_rounded : Icons.favorite_rounded;
    final healthColor = isIOS
        ? const Color(0xFFFF2D55)
        : const Color(0xFF4285F4);

    return SettingsGroup(
      label: l.settingsIntegrations,
      children: [
        SettingsTile.toggle(
          icon: healthIcon,
          iconBgColor: healthColor,
          title: healthTitle,
          subtitle: _healthStatusText(l),
          value: _healthSync,
          onChanged: _healthLoading ? null : _toggleHealthSync,
          isFirst: true,
        ),
        if (!isIOS)
          SettingsTile.toggle(
            icon: Icons.watch_rounded,
            iconBgColor: const Color(0xFF1428A0),
            title: l.samsungHealthTitle,
            subtitle: _samsungStatusText(l),
            value: _samsungHealth,
            onChanged: _samsungLoading ? null : _toggleSamsungHealth,
            isLast: true,
          ),
        if (isIOS)
          SettingsTile(
            icon: Icons.info_outline_rounded,
            iconBgColor: AppColors.moonlight.withValues(alpha: 0.15),
            title: l.sleepDataLabel,
            isLast: true,
            trailing: Text(
              _healthSync ? l.autoWrite : l.off,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: _healthSync
                    ? AppColors.success.withValues(alpha: 0.8)
                    : AppColors.moonlight.withValues(alpha: 0.35),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAppearanceGroup(L l) {
    return SettingsGroup(
      label: l.settingsAppearance,
      children: [
        SettingsTile(
          icon: Icons.dark_mode_rounded,
          iconBgColor: AppColors.nightSky,
          title: l.settingsTheme,
          isFirst: true,
          trailing: SegmentOption<String>(
            options: {
              'dark': l.themeDark,
              'light': l.themeLight,
              'system': l.themeAuto,
            },
            selected: _theme,
            onChanged: (v) => setState(() => _theme = v),
          ),
        ),
        SettingsTile(
          icon: Icons.language_rounded,
          iconBgColor: AppColors.calmBlue,
          title: l.settingsLanguage,
          isLast: true,
          trailing: SegmentOption<String>(
            options: {
              'ru': l.langRu,
              'en': l.langEn,
            },
            selected: _language,
            onChanged: _onLanguageChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountGroup(L l) {
    return SettingsGroup(
      label: l.settingsAccount,
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: ProBanner(onTap: () => _openPaywall()),
        ),
        SettingsTile.navigation(
          icon: Icons.restore_rounded,
          iconBgColor: AppColors.calmBlue.withValues(alpha: 0.8),
          title: l.restorePurchases,
          onTap: () {},
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildAboutGroup(L l) {
    return SettingsGroup(
      label: l.settingsAbout,
      children: [
        SettingsTile.navigation(
          icon: Icons.shield_rounded,
          iconBgColor: AppColors.success.withValues(alpha: 0.8),
          title: l.privacyPolicy,
          onTap: () {},
          isFirst: true,
        ),
        SettingsTile.navigation(
          icon: Icons.description_rounded,
          iconBgColor: AppColors.warning.withValues(alpha: 0.8),
          title: l.termsOfUse,
          onTap: () {},
        ),
        SettingsTile.navigation(
          icon: Icons.star_rounded,
          iconBgColor: AppColors.starYellow,
          title: l.rateApp,
          onTap: () {},
        ),
        SettingsTile(
          icon: Icons.info_outline_rounded,
          iconBgColor: AppColors.moonlight.withValues(alpha: 0.2),
          title: l.version,
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

  void _openPaywall() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const PaywallScreen(),
      ),
    );
  }

  void _openMelodyPicker() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MelodyPickerScreen(
          selectedId: _melodyId,
          onSelected: (id) => setState(() => _melodyId = id),
        ),
      ),
    );
  }

  void _showWakeWindowPicker() {
    final l = L.of(context);
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
                    l.minutesShort(m),
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
