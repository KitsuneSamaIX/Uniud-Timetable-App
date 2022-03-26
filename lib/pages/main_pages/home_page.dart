import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:animations/animations.dart';
import 'package:intl/intl.dart';
import 'package:uniud_timetable_app/pages/settings_page.dart';
import 'package:uniud_timetable_app/pages/main_pages/timetable_page.dart';
import 'package:uniud_timetable_app/pages/main_pages/profiles_page.dart';
import 'package:uniud_timetable_app/profile_configuration_flows/uniud_conf_flow.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Navigation bar
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  // Floating Action Button
  bool _addProfileButtonVisible = false;
  static const double _fabDimension = 56.0;

  late final String _formattedDate;

  @override
  void initState() {
    super.initState();
    // Formatted date string
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, d MMMM');
    _formattedDate = formatter.format(now);
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
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Visibility(
          key: ValueKey<bool>(_addProfileButtonVisible),
          visible: _addProfileButtonVisible,
          child: OpenContainer(
            transitionType: ContainerTransitionType.fade,
            transitionDuration: const Duration(milliseconds: 400),
            openBuilder: (BuildContext context, VoidCallback _) {
              return const DepartmentSelectionPage();
            },
            closedElevation: 6.0,
            closedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(_fabDimension / 2),
              ),
            ),
            closedColor: Theme.of(context).colorScheme.secondary,
            closedBuilder: (BuildContext context, VoidCallback openContainer) {
              return SizedBox(
                height: _fabDimension,
                width: _fabDimension,
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        titleSpacing: 0,
        toolbarHeight: 80,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Today',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5,),
                Text(
                  _formattedDate,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: _SettingsOpenContainer(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Theme.of(context).colorScheme.background,
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
}

class _SettingsOpenContainer extends StatelessWidget {
  static const double _dimension = 32;

  const _SettingsOpenContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      transitionDuration: const Duration(milliseconds: 400),
      openBuilder: (BuildContext context, VoidCallback _) {
        return const SettingsPage();
      },
      closedElevation: 0,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(_dimension / 2),
        ),
      ),
      closedColor: Colors.transparent,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return const SizedBox(
          height: _dimension,
          width: _dimension,
          child: Center(
            child: Icon(
              Icons.settings,
              size: 32,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }
}
