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
            transitionDuration: const Duration(milliseconds: 350),
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
        title: Row(
          children: [
            Expanded(
              child: _TodayHeading(
                date: DateTime.now(),
                padding: const EdgeInsets.all(16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: _SettingsOpenContainer(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        selectedIndex: _selectedIndex,
        showElevation: true,
        animationDuration: const Duration(milliseconds: 250),
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
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
        physics: const NeverScrollableScrollPhysics(),
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

class _TodayHeading extends StatelessWidget {
  final DateTime date;
  final EdgeInsetsGeometry padding;

  const _TodayHeading({Key? key, required this.date, required this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Formatted date string
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, d MMMM');
    final formattedDate = formatter.format(now);

    return Padding(
      padding: padding,
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
            formattedDate,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
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
      transitionDuration: const Duration(milliseconds: 250),
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
