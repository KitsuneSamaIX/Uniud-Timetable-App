import 'package:flutter/material.dart';
import 'package:uniud_timetable_app/pages/main_pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UNIUD Timetable App',
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        brightness: Brightness.light,
        // backgroundColor: Colors.white,
      ),
      home: const HomePage(),
    );
  }
}
