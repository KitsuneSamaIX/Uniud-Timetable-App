import 'package:flutter/material.dart';
import 'package:uniud_timetable_app/custom_widgets/week_timeline.dart';

class TimetableManager extends ChangeNotifier {
  var _selectedDate = _normalizeDate(DateTime.now());

  late final WeekTimelineController _weekTimelineController;
  late final PageController _lessonsPageController;

  TimetableManager() {
    _weekTimelineController = WeekTimelineController(initialDate: _selectedDate);
    _lessonsPageController = PageController(initialPage: 1000);
  }

  // PUBLIC API

  WeekTimelineController get weekTimelineController => _weekTimelineController;

  PageController get lessonsPageController => _lessonsPageController;

  DateTime get selectedDate => _selectedDate;

  /// Goes to the specified date.
  ///
  /// This will automatically keep in sync the WeekTimeline's selected date and
  /// the view of the selected date's lessons.
  ///
  /// Transition animations are also performed automatically.
  void gotoDate(DateTime date) {
    date = _normalizeDate(date);
    _selectedDate = date;
    _weekTimelineController.gotoDate(date);
    // _lessonsPageController.animateToPage(
    //   index, // TODO convert date to page index
    //   duration: const Duration(milliseconds: 200),
    //   curve: Curves.easeOutCubic,
    // );
  }

  @override
  void dispose() {
    _weekTimelineController.dispose();
    _lessonsPageController.dispose();
    super.dispose();
  }
}

/// Returns the normalized date.
///
/// This is useful to avoid potential errors with daylight saving time.
DateTime _normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day, 12);
}
