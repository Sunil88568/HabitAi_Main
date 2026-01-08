import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const String _themeKey = 'theme_mode';
  
  final Rx<ThemeMode> _themeMode = ThemeMode.dark.obs;
  
  ThemeMode get themeMode => _themeMode.value;
  bool get isDarkMode => _themeMode.value == ThemeMode.dark;
  bool get isLightMode => _themeMode.value == ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  /// Load theme preference from SharedPreferences
  Future<void> _loadThemeFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);
      
      if (savedTheme != null) {
        _themeMode.value = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == savedTheme,
          orElse: () => ThemeMode.dark,
        );
      }
    } catch (e) {
      print('Error loading theme preference: $e');
    }
  }

  /// Save theme preference to SharedPreferences
  Future<void> _saveThemeToPrefs(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, mode.toString());
    } catch (e) {
      print('Error saving theme preference: $e');
    }
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    final newMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  /// Set specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode.value = mode;
    Get.changeThemeMode(mode);
    await _saveThemeToPrefs(mode);
  }

  /// Set light theme
  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }

  /// Set dark theme
  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }
}