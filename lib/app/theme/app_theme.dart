import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Primary brand color used across the app (kept as a single source)
  static const Color primaryColor = Color(0xFF673AB7);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
        seedColor: Colors.deepPurple,
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
