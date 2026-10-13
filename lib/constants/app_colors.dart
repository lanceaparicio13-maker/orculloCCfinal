import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF101018);
  static const panel = Color(0xFF1C1C2A);
  static const purple = Color(0xFF8B5CF6);
  static const cyan = Color(0xFF22D3EE);
  static const white = Colors.white;
  static const muted = Color(0xFFAAAABD);

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: purple,
        secondary: cyan,
        surface: panel,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: white,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: panel,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: purple,
        secondary: cyan,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );
  }
}