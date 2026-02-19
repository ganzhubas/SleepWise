import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/alarm/alarm_screen.dart';
import '../features/statistics/statistics_screen.dart';
import '../features/settings/settings_screen.dart';
import '../core/theme/app_colors.dart';
import '../services/notification_service.dart';

/// Bottom tab shell: Alarm / Statistics / Settings.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  static const _screens = <Widget>[
    AlarmScreen(),
    StatisticsScreen(),
    SettingsScreen(),
  ];

  static const _batteryWarningKey = 'battery_warning_shown';

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
    _checkBatteryOptimization();
  }

  Future<void> _requestNotificationPermission() async {
    await NotificationService.instance.requestPermission();
  }

  Future<void> _checkBatteryOptimization() async {
    if (!Platform.isAndroid) return;

    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_batteryWarningKey) == true) return;

    // Check if device is from an OEM known for aggressive battery optimization
    final manufacturer = await _getManufacturer();
    final needsWarning = [
      'xiaomi',
      'redmi',
      'poco',
      'samsung',
      'huawei',
      'honor',
      'oppo',
      'vivo',
      'oneplus',
      'realme',
      'meizu',
    ].any((m) => manufacturer.contains(m));

    if (!needsWarning || !mounted) return;

    // Small delay to let the UI settle
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    await _showBatteryWarningDialog(manufacturer);
    await prefs.setBool(_batteryWarningKey, true);
  }

  Future<String> _getManufacturer() async {
    try {
      // Read from Android build properties via /system/build.prop
      final file = File('/system/build.prop');
      if (await file.exists()) {
        final content = await file.readAsString();
        final match =
            RegExp(r'ro\.product\.manufacturer=(.+)').firstMatch(content);
        if (match != null) return match.group(1)!.toLowerCase().trim();
      }
    } catch (_) {}
    return '';
  }

  Future<void> _showBatteryWarningDialog(String manufacturer) async {
    String brand = 'вашего устройства';
    if (manufacturer.contains('xiaomi') ||
        manufacturer.contains('redmi') ||
        manufacturer.contains('poco')) {
      brand = 'Xiaomi';
    } else if (manufacturer.contains('samsung')) {
      brand = 'Samsung';
    } else if (manufacturer.contains('huawei') ||
        manufacturer.contains('honor')) {
      brand = 'Huawei';
    } else if (manufacturer.contains('oppo') ||
        manufacturer.contains('realme')) {
      brand = 'OPPO';
    } else if (manufacturer.contains('vivo')) {
      brand = 'Vivo';
    } else if (manufacturer.contains('oneplus')) {
      brand = 'OnePlus';
    }

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.battery_alert_rounded,
                color: AppColors.warning, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Оптимизация батареи',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: AppColors.moonlight,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Устройства $brand могут завершать работу приложений '
          'в фоновом режиме.\n\n'
          'Для надёжной работы будильника отключите оптимизацию '
          'батареи для SleepWise в настройках устройства.\n\n'
          'Подробнее: dontkillmyapp.com',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            height: 1.5,
            color: AppColors.moonlight.withValues(alpha: 0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Позже',
              style: TextStyle(
                fontFamily: 'Inter',
                color: AppColors.moonlight.withValues(alpha: 0.5),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _openBatterySettings();
            },
            child: Text(
              'Открыть настройки',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                color: AppColors.calmBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openBatterySettings() async {
    try {
      // Open battery optimization settings via Android intent
      const channel = MethodChannel('dev.sleepwise/battery_settings');
      await channel.invokeMethod('openBatterySettings');
    } catch (_) {
      // Fallback: show a snackbar with manual instructions
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Откройте Настройки → Батарея → SleepWise → Без ограничений',
              style: TextStyle(fontFamily: 'Inter'),
            ),
            backgroundColor: AppColors.darkSurface,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.moonlight.withValues(alpha: 0.06),
                width: 0.5,
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            backgroundColor: AppColors.nightSky,
            selectedItemColor: AppColors.calmBlue,
            unselectedItemColor: AppColors.moonlight.withValues(alpha: 0.3),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.alarm_rounded),
                label: 'Будильник',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_rounded),
                label: 'Статистика',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_rounded),
                label: 'Настройки',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
