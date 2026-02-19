import 'package:flutter/material.dart';
import '../features/alarm/alarm_screen.dart';
import '../features/statistics/statistics_screen.dart';
import '../features/settings/settings_screen.dart';
import '../core/theme/app_colors.dart';

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
