import 'package:flutter/material.dart';
import 'package:sleepwise/core/theme/app_theme.dart';
import 'package:sleepwise/l10n/app_localizations.dart';

/// Wraps a widget in a MaterialApp with localization support for testing.
Widget localizedApp({
  required Widget home,
  ThemeData? theme,
  Map<String, WidgetBuilder>? routes,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: theme ?? AppTheme.dark,
    locale: const Locale('ru'),
    localizationsDelegates: L.localizationsDelegates,
    supportedLocales: L.supportedLocales,
    routes: routes ?? const <String, WidgetBuilder>{},
    home: home,
  );
}
