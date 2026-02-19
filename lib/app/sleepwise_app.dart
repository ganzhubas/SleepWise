import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../features/showcase/widget_showcase_screen.dart';
import '../l10n/app_localizations.dart';
import 'router.dart';

/// Global notifier for locale switching from settings.
final localeNotifier = ValueNotifier<Locale?>(null);

class SleepWiseApp extends StatelessWidget {
  const SleepWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: localeNotifier,
      builder: (context, locale, _) {
        return MaterialApp(
          title: 'SleepWise',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.dark,
          locale: locale,
          localizationsDelegates: L.localizationsDelegates,
          supportedLocales: L.supportedLocales,
          onGenerateRoute: AppRouter.onGenerateRoute,
          home: const WidgetShowcaseScreen(),
        );
      },
    );
  }
}
