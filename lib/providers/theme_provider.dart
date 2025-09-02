import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isDarkMode = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    
    notifyListeners();
  }

  Future<void> setTheme(bool isDark) async {
    _isDarkMode = isDark;
    _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    
    notifyListeners();
  }
}
