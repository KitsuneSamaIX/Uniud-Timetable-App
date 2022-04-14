import 'package:flutter/material.dart';
import 'package:uniud_timetable_app/custom_widgets/week_timeline.dart';

class TimetableManager {
  static const int _viewableDatesRadius = 1000 * 7; // TODO maybe I should link this '1000' with the _viewableWeeksRadius constant
  static const int _totalViewableDates = (_viewableDatesRadius * 2) + 1;
  final int _currentDateIndex = (_totalViewableDates / 2).floor();

  final DateTime _currentDate = _normalizeDate(DateTime.now());

  late final WeekTimelineController _weekTimelineController;
  late final PageController _lessonsPageController;

  TimetableManager() {
    _weekTimelineController = WeekTimelineController(initialDate: _currentDate);
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
    // No need to also call lessonsPageController.animateToPage (or jumpToPage),
    // calling WeekTimelineController.gotoDate will trigger the onDateSelected
    // callback defined for the WeekTimeline widget, the callback will be
    // responsible for the call of lessonsPageController.animateToPage.
  }

  /// Convenience method that calls [PageController.animateToPage] with
  /// predefined animation parameters.
  ///
  /// This method returns the result of the call to [PageController.animateToPage].
  Future<void> lessonsPageControllerAnimateToPage(int page) {
    return _lessonsPageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  // CONVERSIONS

  int dateToLessonsPageIndex(DateTime date) {
    date = _normalizeDate(date);

    final difference = _currentDate.difference(date).inDays;
    return _currentDateIndex - difference;
  }

  DateTime lessonsPageIndexToDate(int index) {
    final difference = index - _currentDateIndex;
    return _currentDate.add(Duration(days: difference));
  }

  // DISPOSE

  void dispose() {
    _weekTimelineController.dispose();
    _lessonsPageController.dispose();
  }
}

/// Returns the normalized date.
///
/// This is useful to avoid potential errors with daylight saving time.
DateTime _normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day, 12);
}
