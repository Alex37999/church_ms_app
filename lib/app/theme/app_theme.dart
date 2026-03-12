import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFF123A75);
  static const Color brandNavy = Color(0xFF0D2B56);
  static const Color accentGreen = Color(0xFF22C55E);
  static const Color pageBackground = Color(0xFFF5F7FB);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surfaceSubtle = Color(0xFFF8FBFF);
  static const Color cardBorder = Color(0xFFE4EAF2);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF667085);
  static const Color info = Color(0xFF2563EB);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFEA580C);
  static const Color softBlue = Color(0xFFEAF2FF);
  static const Color softGreen = Color(0xFFEFFAF3);
  static const Color softViolet = Color(0xFFF5F3FF);
  static const Color softOrange = Color(0xFFFFF7ED);
  static const Color headerBackground = Color.fromARGB(255, 5, 35, 77);

  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    final poppinsTextTheme = GoogleFonts.poppinsTextTheme(base.textTheme);
    final poppinsPrimaryTextTheme = GoogleFonts.poppinsTextTheme(
      base.primaryTextTheme,
    );

    return ThemeData(
      fontFamily: GoogleFonts.poppins().fontFamily,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor).copyWith(
        primary: primaryColor,
        secondary: accentGreen,
        surface: cardBackground,
        surfaceContainerLow: cardBackground,
        outline: cardBorder,
        outlineVariant: cardBorder,
        onSurface: textPrimary,
      ),
      brightness: Brightness.light,
      scaffoldBackgroundColor: pageBackground,
      canvasColor: cardBackground,
      dividerColor: cardBorder,
      textTheme: poppinsTextTheme.apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      primaryTextTheme: poppinsPrimaryTextTheme.apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: pageBackground,
        elevation: 0,
        centerTitle: true,
        foregroundColor: textPrimary,
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 6,
        margin: EdgeInsets.zero,
        shadowColor: const Color.fromRGBO(15, 23, 42, 0.08),
        surfaceTintColor: cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: cardBorder),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardBackground,
        selectedItemColor: brandNavy,
        unselectedItemColor: textSecondary,
        selectedIconTheme: IconThemeData(color: brandNavy),
        unselectedIconTheme: IconThemeData(color: textSecondary),
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryColor,
          foregroundColor: cardBackground,
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: cardBorder),
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    final poppinsTextTheme = GoogleFonts.poppinsTextTheme(base.textTheme);
    final poppinsPrimaryTextTheme = GoogleFonts.poppinsTextTheme(
      base.primaryTextTheme,
    );

    return ThemeData(
      fontFamily: GoogleFonts.poppins().fontFamily,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ),
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      textTheme: poppinsTextTheme,
      primaryTextTheme: poppinsPrimaryTextTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212),
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
