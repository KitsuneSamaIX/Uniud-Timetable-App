import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  // Theme (with defaults)
  FlexScheme _flexScheme = FlexScheme.green;
  ThemeMode _themeMode = ThemeMode.dark;
  bool _darkIsTrueBlack = false;

  FlexScheme get flexScheme => _flexScheme;

  ThemeMode get themeMode => _themeMode;

  bool get darkIsTrueBlack => _darkIsTrueBlack;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final flexSchemeIndex = prefs.getInt('flexScheme');
    if (flexSchemeIndex != null) {
      _flexScheme = FlexScheme.values[flexSchemeIndex];
    }

    final themeModeIndex = prefs.getInt('themeMode');
    if (themeModeIndex != null) {
      _themeMode = ThemeMode.values[themeModeIndex];
    }

    _darkIsTrueBlack = prefs.getBool('darkIsTrueBlack') ?? _darkIsTrueBlack;
  }

  void setFlexScheme(FlexScheme flexScheme) {
    if (_flexScheme != flexScheme) {
      _flexScheme = flexScheme;
      notifyListeners();
      SharedPreferences.getInstance().then((prefs) =>
          prefs.setInt('flexScheme', _flexScheme.index));
    }
  }

  void setThemeMode(ThemeMode themeMode) {
    if (_themeMode != themeMode) {
      _themeMode = themeMode;
      notifyListeners();
      SharedPreferences.getInstance().then((prefs) =>
          prefs.setInt('themeMode', _themeMode.index));
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
