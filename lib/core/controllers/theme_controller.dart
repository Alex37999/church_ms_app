import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final isDark = false.obs;

  void toggleTheme() => isDark.value = !isDark.value;

  Color get cardColor => isDark.value ? const Color(0xFF1E1E1E) : Colors.white;
  Color get primaryText => isDark.value ? Colors.white : Colors.black87;
  Color get secondaryText => isDark.value ? Colors.white70 : Colors.black54;
  Color get inputFill => isDark.value ? const Color(0xFF2A2A2A) : const Color(0xFFF2F3F7);
  Color get inputIconColor => isDark.value ? Colors.white70 : Colors.black45;
}
