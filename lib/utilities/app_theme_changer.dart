import 'package:flutter/material.dart';

class AppThemeModel extends ChangeNotifier {
  var colorSchemeSeed = Colors.teal;
  var themeMode = ThemeMode.system;

  void setThemeMode(ThemeMode themeMode) {
    if (this.themeMode != themeMode) {
      this.themeMode = themeMode;
      notifyListeners();
    }
  }

  void setColorSchemeSeed(MaterialColor colorSchemeSeed) {
    if (this.colorSchemeSeed != colorSchemeSeed) {
      this.colorSchemeSeed = colorSchemeSeed;
      notifyListeners();
    }
  }

  void setTheme({ThemeMode? themeMode, MaterialColor? colorSchemeSeed}) {
    if (themeMode != null || colorSchemeSeed != null) {
      if (this.themeMode != themeMode || this.colorSchemeSeed != colorSchemeSeed) {
        this.themeMode = themeMode ?? this.themeMode;
        this.colorSchemeSeed = colorSchemeSeed ?? this.colorSchemeSeed;
        notifyListeners();
      }
    }
  }
}
