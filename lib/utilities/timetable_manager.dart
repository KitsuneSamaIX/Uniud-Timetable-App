import 'package:flutter/material.dart';
import 'package:uniud_timetable_app/custom_widgets/week_timeline.dart';

class TimetableManager {
  final int _viewableWeeksRadius = 1000;
  // Convert the number of weeks in the number of dates
  late final int _viewableDatesRadius = _viewableWeeksRadius * 7;
  // Add the two radiuses to the central week (7 dates) to compute the total
  late final int totalViewableDates = (_viewableDatesRadius * 2) + 7;
  // Compute the current date index, note that we are inside a week (which starts
  // with monday), so we are not always at the center of the week hence we need
  // to offset the obtained index.
  late final int _currentDateIndex = (totalViewableDates / 2).floor() - 3 + (_currentDate.weekday - 1);

  final DateTime _currentDate = _normalizeDate(DateTime.now());

  late final WeekTimelineController _weekTimelineController;
  late final PageController _lessonsPageController;

  TimetableManager() {
    _weekTimelineController = WeekTimelineController(
        viewableWeeksRadius: _viewableWeeksRadius, initialDate: _currentDate);
    _lessonsPageController = PageController(initialPage: _currentDateIndex);
  }

  // PUBLIC API

  DateTime get selectedDate => _weekTimelineController.selectedDate;

  WeekTimelineController get weekTimelineController => _weekTimelineController;

  PageController get lessonsPageController => _lessonsPageController;
  bool lessonsPageControllerIsAnimatingToPage = false;

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
  /// predefined animation parameters and automatically sets [lessonsPageControllerIsAnimatingToPage].
  ///
  /// This method returns the result of the call to [PageController.animateToPage].
  Future<void> lessonsPageControllerAnimateToPage(int page) {
    lessonsPageControllerIsAnimatingToPage = true;
    return _lessonsPageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    ).whenComplete(() => lessonsPageControllerIsAnimatingToPage = false);
  }

  DateTime get firstPickableDate =>
      _currentDate.subtract(Duration(days: _viewableDatesRadius));

  DateTime get lastPickableDate =>
      _currentDate.add(Duration(days: _viewableDatesRadius));

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
