import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  static const String _poppins = 'Poppins';
  static const String _inter = 'Inter';
  static const String mono = 'JetBrainsMono';

  static TextTheme get textTheme {
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: _poppins,
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: TextStyle(
        fontFamily: _poppins,
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: TextStyle(
        fontFamily: _poppins,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        fontFamily: _poppins,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: TextStyle(
        fontFamily: _poppins,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        fontFamily: _poppins,
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
