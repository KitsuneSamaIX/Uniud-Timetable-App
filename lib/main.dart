import 'dart:math';

import 'package:flutter/material.dart';
import 'package:uniud_timetable_app/profile_configuration_flows/uniud_conf_flow.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

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
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Navigation bar
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  // Add profile Floating Action Button
  bool _addProfileButtonVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: Visibility(
        visible: _addProfileButtonVisible,
        child: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () { showAboutDialog(context: context); },
        ),
      ), // TODO
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Today',
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      'Monday, 22 March',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                iconSize: 30,
                color: Colors.grey,
                onPressed: _pushSettingsPage,
                icon: const Icon(Icons.settings),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        }),
        items: [
          BottomNavyBarItem(
            icon: const Icon(Icons.apps),
            title: const Text('Timetable'),
            activeColor: Colors.red,
          ),
          BottomNavyBarItem(
              icon: const Icon(Icons.people),
              title: const Text('Profiles'),
              activeColor: Colors.purpleAccent
          ),
          // BottomNavyBarItem(
          //     icon: const Icon(Icons.settings),
          //     title: const Text('Settings'),
          //     activeColor: Colors.blue
          // ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() {
          _selectedIndex = index;
          if (index == 1) {
            _addProfileButtonVisible = true;
          } else {
            _addProfileButtonVisible = false;
          }
        }),
        children: const [
          TimetablePage(),
          ProfilesPage(),
        ],
      ),
    );
  }

  void _pushSettingsPage() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const ProfilesPage(),
      ),
    );
  }
}

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key? key}) : super(key: key);

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Expanded(
          child: Center(
            child: Text(
              'Hello Fellow Student!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfilesPage extends StatefulWidget {
  const ProfilesPage({Key? key}) : super(key: key);

  @override
  State<ProfilesPage> createState() => _ProfilesPageState();
}

class _ProfilesPageState extends State<ProfilesPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton(
        child: const Text("Create Timetable"),
        onPressed: _pushDepartmentSelectionPage,
      ),
    );
  }

  void _pushDepartmentSelectionPage() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const DepartmentSelectionPage(),
      ),
    );
  }
}
