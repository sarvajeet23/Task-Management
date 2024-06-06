import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage();
  final _key = "isDarkMode";

  // Singleton instance of ThemeController
  static final ThemeController _instance = Get.put(ThemeController());

  // Get the theme mode from local storage
  ThemeMode get theme => _loadThemeFromStorage() ? ThemeMode.dark : ThemeMode.light;

  // Load theme from storage
  bool _loadThemeFromStorage() => _storage.read(_key) ?? false;

  // Save the theme to storage
  void _saveThemeToStorage(bool isDarkMode) => _storage.write(_key, isDarkMode);

  // Toggle theme and save the preference
  void toggleTheme() {
    bool isDarkMode = _loadThemeFromStorage();
    Get.changeThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToStorage(!isDarkMode);
  }

  // Static method to toggle the theme
  static void ThemeSwitch() {
    _instance.toggleTheme();
  }

  // Static method to get the current theme
  static ThemeMode get currentTheme => _instance.theme;
}
