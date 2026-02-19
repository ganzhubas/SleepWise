import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  static const String _montserrat = 'Montserrat';
  static const String _inter = 'Inter';
  static const String mono = 'JetBrainsMono';

  static TextTheme get textTheme {
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: _montserrat,
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: TextStyle(
        fontFamily: _montserrat,
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: TextStyle(
        fontFamily: _montserrat,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        fontFamily: _montserrat,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: TextStyle(
        fontFamily: _montserrat,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        fontFamily: _montserrat,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        fontFamily: _inter,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        fontFamily: _inter,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontFamily: _inter,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        fontFamily: _inter,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
