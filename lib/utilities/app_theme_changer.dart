import 'package:flutter/material.dart';

class AppThemeModel extends ChangeNotifier {
  /// Private field containing the app's current theme. It also defines the
  /// app's default theme.
  ThemeData _theme = ThemeData(
    colorSchemeSeed: Colors.teal,
    brightness: Brightness.dark,
  );

  ThemeData get theme => _theme;

  void setTheme(ThemeData theme) {
    _theme = theme;
    notifyListeners();
  }
}
