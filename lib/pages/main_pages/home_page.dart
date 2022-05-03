import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uniud_timetable_app/pages/settings_page.dart';
import 'package:uniud_timetable_app/pages/main_pages/timetable_page.dart';
import 'package:uniud_timetable_app/pages/main_pages/profiles_page.dart';
import 'package:uniud_timetable_app/profile_configuration_flows/uniud_conf_flow.dart';
import 'package:uniud_timetable_app/utilities/timetable_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Navigation bar
  int _selectedPageIndex = 0;
  final PageController _pageController = PageController();

  // Floating Action Button
  bool _addProfileButtonVisible = false;
  static const double _fabDimension = 56.0;

  // Headings
  final _pageHeadings = ['Timetable', 'Profiles'];

  // Timetable page
  final _timetableManager = TimetableManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Visibility(
          key: ValueKey<bool>(_addProfileButtonVisible), // This is for the animation
          visible: _addProfileButtonVisible,
          child: OpenContainer(
            transitionType: ContainerTransitionType.fade,
            transitionDuration: const Duration(milliseconds: 350),
            openBuilder: (BuildContext context, VoidCallback _) {
              return DepartmentSelectionPage();
            },
            closedElevation: 6.0,
            closedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(_fabDimension / 2),
              ),
            ),
            closedColor: Theme.of(context).colorScheme.primary,
            closedBuilder: (BuildContext context, VoidCallback openContainer) {
              return SizedBox(
                height: _fabDimension,
                width: _fabDimension,
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        titleSpacing: 0,
        toolbarHeight: 80,
        title: Row(
          children: [
            Expanded(
              child: _Heading(
                title: _pageHeadings[_selectedPageIndex],
                padding: const EdgeInsets.all(16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Visibility(
                visible: _selectedPageIndex == 0,
                child: IconButton(
                  onPressed: () => _timetableManager.gotoDate(DateTime.now()),
                  color: Theme.of(context).colorScheme.secondary,
                  iconSize: 32,
                  icon: const Icon(Icons.today),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: _SettingsOpenContainer(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        animationDuration: const Duration(milliseconds: 300),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: _selectedPageIndex,
        onDestinationSelected: (index) => setState(() {
          _selectedPageIndex = index;
          _pageController.jumpToPage(index);
        }),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.apps),
            label: 'Timetable',
            tooltip: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.people),
            label: 'Profiles',
            tooltip: '',
          )
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) => setState(() {
          _selectedPageIndex = index;
          if (index == 1) {
            _addProfileButtonVisible = true;
          } else {
            _addProfileButtonVisible = false;
          }
        }),
        children: [
          Provider.value(
            value: _timetableManager,
            child: const TimetablePage(),
          ),
          const ProfilesPage(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timetableManager.dispose();
    super.dispose();
  }
}

class _Heading extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry padding;

  const _Heading({Key? key, required this.title, required this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
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
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 5,),
          Text(
            formattedDate,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 24,
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
        return SizedBox(
          height: _dimension + 8,
          width: _dimension + 8,
          child: Center(
            child: Icon(
              Icons.settings,
              size: _dimension,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        );
      },
    );
  }
}
