import 'package:flutter/material.dart';
import 'package:uniud_timetable_app/custom_widgets/week_timeline.dart';

class TimetableManager extends ChangeNotifier {
  static const int _viewableDatesRadius = 1000 * 7; // TODO maybe should link with the 1000 with the _viewableWeeksRadius constant
  static const int _totalViewableDates = (_viewableDatesRadius * 2) + 1;
  final int _currentDateIndex = (_totalViewableDates / 2).floor();

  late final WeekTimelineController _weekTimelineController;
  late final PageController _lessonsPageController;

  TimetableManager() {
    _weekTimelineController = WeekTimelineController(initialDate: DateTime.now());
    _lessonsPageController = PageController(initialPage: _currentDateIndex);
  }

  // PUBLIC API

  DateTime get selectedDate => _weekTimelineController.selectedDate;

  WeekTimelineController get weekTimelineController => _weekTimelineController;

  PageController get lessonsPageController => _lessonsPageController;

  /// Goes to the specified date.
  ///
  /// This will automatically keep in sync the WeekTimeline's selected date and
  /// the view of the selected date's lessons.
  ///
  /// Transition animations are also performed automatically.
  void gotoDate(DateTime date) {
    date = _normalizeDate(date);

    _weekTimelineController.gotoDate(date);

    // _lessonsPageController.animateToPage(
    //   index, // TODO convert date to page index
    //   duration: const Duration(milliseconds: 200),
    //   curve: Curves.easeOutCubic,
    // );
  }

  int dateToLessonsPageIndex(DateTime date) {
    date = _normalizeDate(date);
    // TODO implement
  }

  DateTime lessonsPageIndexToDate(int index) {
    // TODO implement
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
