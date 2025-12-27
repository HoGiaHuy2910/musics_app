import 'package:flutter/material.dart';

class ThemeController {
  ThemeController._();
  static final instance = ThemeController._();

  // true = dark, false = light
  final ValueNotifier<bool> isDark = ValueNotifier(false);

  void toggle(bool value) {
    isDark.value = value;
  }
}
