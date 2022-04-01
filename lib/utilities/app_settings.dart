import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  // Theme (with defaults)
  FlexScheme _flexScheme = FlexScheme.aquaBlue;
  ThemeMode _themeMode = ThemeMode.dark;

  FlexScheme get flexScheme => _flexScheme;

  ThemeMode get themeMode => _themeMode;

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
}
