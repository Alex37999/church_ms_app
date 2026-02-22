import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Primary brand color used across the app (kept as a single source)
  // Aligned with the blue used in home/profile screens
  static const Color primaryColor = Color(0xFF5B6FFF);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFFBFCFF),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFBFCFF),
        elevation: 0,
        centerTitle: true,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ),
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212),
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
