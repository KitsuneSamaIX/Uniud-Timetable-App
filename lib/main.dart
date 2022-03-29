import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uniud_timetable_app/pages/main_pages/home_page.dart';
import 'package:uniud_timetable_app/utilities/app_theme_changer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppThemeModel(),
      child: const MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  const MaterialAppWithTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<AppThemeModel>(context);
    return MaterialApp(
      title: 'UNIUD Timetable App',
      theme: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: themeProvider.colorSchemeSeed,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: themeProvider.colorSchemeSeed,
      ),
      themeMode: themeProvider.themeMode,
      home: const HomePage(),
    );
  }
}
