import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniud_timetable_app/pages/settings_page.dart';

class AppSettings extends ChangeNotifier {
  // Theme (with defaults)
  ThemeMode _themeMode = ThemeMode.dark;
  AppKeyColor _appKeyColor = AppKeyColor.teal;
  bool _darkIsTrueBlack = false;

  ThemeMode get themeMode => _themeMode;

  AppKeyColor get appKeyColor => _appKeyColor;

  bool get darkIsTrueBlack => _darkIsTrueBlack;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final themeModeIndex = prefs.getInt('themeMode');
    if (themeModeIndex != null) {
      _themeMode = ThemeMode.values[themeModeIndex];
    }

    final appKeyColorIndex = prefs.getInt('appKeyColor');
    if (appKeyColorIndex != null) {
      _appKeyColor = AppKeyColor.values[appKeyColorIndex];
    }

    _darkIsTrueBlack = prefs.getBool('darkIsTrueBlack') ?? _darkIsTrueBlack;
  }

  void setThemeMode(ThemeMode themeMode) {
    if (_themeMode != themeMode) {
      _themeMode = themeMode;
      notifyListeners();
      SharedPreferences.getInstance().then((prefs) =>
          prefs.setInt('themeMode', _themeMode.index));
    }
  }

  void setAppKeyColor(AppKeyColor appKeyColor) {
    if (_appKeyColor != appKeyColor) {
      _appKeyColor = appKeyColor;
      notifyListeners();
      SharedPreferences.getInstance().then((prefs) =>
          prefs.setInt('appKeyColor', _appKeyColor.index));
    }
  }

  void setDarkIsTrueBlack(bool darkIsTrueBlack) {
    if (_darkIsTrueBlack != darkIsTrueBlack) {
      _darkIsTrueBlack = darkIsTrueBlack;
      notifyListeners();
      SharedPreferences.getInstance().then((prefs) =>
          prefs.setBool('darkIsTrueBlack', _darkIsTrueBlack));
    }
  }
}
