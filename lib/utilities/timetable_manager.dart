import 'package:flutter/material.dart';

class TimetableManager extends ChangeNotifier {
  /// The radius of the viewable days in timeline with [DateTime.now] as pivot.
  ///
  /// |----[_viewableDaysRadius]----|--[DateTime.now]--|----[_viewableDaysRadius]----|
  ///
  /// The total number of viewable days will be: [_viewableDaysRadius]*2 + 1
  /// Hence, the pivot will always be at the index [_viewableDaysRadius].
  static const _viewableDaysRadius = 500;

  final _pageController = PageController(initialPage: _viewableDaysRadius);

  final _pivotDay = _normalizeDay(DateTime.now());
  late final DateTime _firstDay;
  late final DateTime _lastDay;
  late DateTime _selectedDay;

  /// The default date/index of this manager is the current day.
  TimetableManager() {
    _firstDay = _normalizeDay(_pivotDay.subtract(const Duration(days: _viewableDaysRadius)));
    _lastDay = _normalizeDay(_pivotDay.add(const Duration(days: _viewableDaysRadius)));
    _selectedDay = _pivotDay;
  }

  // PUBLIC API

  /// Note: PageController index and selected day are always in sync.
  PageController get pageController => _pageController;

  DateTime get firstDay => _firstDay;

  DateTime get lastDay => _lastDay;

  /// Note: PageController index and selected day are always in sync.
  DateTime get selectedDay => _selectedDay;

  /// Note: PageController index and selected day are always in sync.
  void gotoIndex(int index) {
    _selectedDay = indexToDay(index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
    );
  }

  /// Note: PageController index and selected day are always in sync.
  void gotoDay(DateTime day) {
    day = _normalizeDay(day);
    _selectedDay = day;
    _pageController.animateToPage(
      dayToIndex(day),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
    );
  }

  // UTILITY

  /// Normalization prevents errors that originate from legal hour changes.
  static DateTime _normalizeDay(DateTime day) {
    return DateTime(day.year, day.month, day.day, 12);
  }

  DateTime indexToDay(int index) {
    return _firstDay.add(Duration(days: index));
  }

  int dayToIndex(DateTime day) {
    day = _normalizeDay(day);
    return day.difference(_firstDay).inDays;
  }
}
