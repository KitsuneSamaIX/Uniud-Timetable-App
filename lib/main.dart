import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uniud_timetable_app/pages/main_pages/home_page.dart';
import 'package:uniud_timetable_app/utilities/app_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load app settings
  final appSettings = AppSettings();
  await appSettings.loadSettings();

  runApp(MyApp(appSettings: appSettings,));
}

class MyApp extends StatelessWidget {
  final AppSettings appSettings;

  const MyApp({Key? key, required this.appSettings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: appSettings,
      child: const MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  const MaterialAppWithTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appSettingsProvider = Provider.of<AppSettings>(context);
    return MaterialApp(
      title: 'UNIUD Timetable App',
      theme: FlexThemeData.light(
        scheme: appSettingsProvider.flexScheme,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: appSettingsProvider.flexScheme,
      ),
      themeMode: appSettingsProvider.themeMode,
      home: const HomePage(),
    );
  }
}
