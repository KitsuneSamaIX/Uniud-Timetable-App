import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uniud_timetable_app/common/common.dart' show separateWidgets;

class WeekTimeline extends StatefulWidget {
  final WeekTimelineController controller;
  final void Function()? onDateSelected;

  const WeekTimeline({
    Key? key,
    required this.controller,
    this.onDateSelected,
  }) : super(key: key);

  @override
  State<WeekTimeline> createState() => _WeekTimelineState();
}

class _WeekTimelineState extends State<WeekTimeline> with AutomaticKeepAliveClientMixin {
  static const int _viewableWeeksRadius = 250;
  static const int _totalWeeks = (_viewableWeeksRadius * 2) + 1;
  final int _currentWeekIndex = (_totalWeeks / 2).floor();

  final DateTime _currentDate = _normalizeDate(DateTime.now());

  late final List<_Week> _weeks;

  late final _pageController = PageController(initialPage: _currentWeekIndex);

  @override
  void initState() {
    print('_WeekTimelineState.initState');
    super.initState();
    _initWeeks(); // TODO SERIOUS performace problem, Optimize (avoid create every time i change page on bottom nav bar)
    widget.controller.addListener(_dateSelectionListener);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height: 70,
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        onPageChanged: (index) {
          widget.controller.selectedDate = _weeks[index]
              .weekDates[widget.controller.selectedDate.weekday-1];
        },
        itemBuilder: (context, index) {
          final selectedWeek = _weeks[index];
          final selectedWeekDates = selectedWeek.weekDates;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: List.generate(selectedWeekDates.length, (j) {
                  return _DayTile(
                    date: selectedWeekDates[j],
                    isSelected: _areDatesEqual(
                        selectedWeekDates[j], widget.controller.selectedDate),
                    onTap: () {
                      widget.controller.selectedDate = selectedWeekDates[j];
                    },
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    widget.controller.removeListener(_dateSelectionListener);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void _dateSelectionListener() {
    setState(() {}); // Rebuild widget
    if (widget.onDateSelected != null) {
      widget.onDateSelected!();
    }
  }

  void _initWeeks() {
    // Note: we generate the weeks starting from the pivot to be resilient
    // against daylight saving hours.
    List<_Week> weeks = List.filled(
      _totalWeeks,
      _Week(weekFirstDate: DateTime(0)), // This is a placeholder
      growable: false,
    );

    // Generate current week
    weeks[_currentWeekIndex] = _Week.fromPreviousMondayOf(date: _currentDate);

    // Generate weeks before current week
    for (int i = _currentWeekIndex-1; i > 0; i--) {
      weeks[i] = weeks[i+1].previousWeek;
    }

    // Generate weeks after current week
    for (int i = _currentWeekIndex+1; i < _totalWeeks; i++) {
      weeks[i] = weeks[i-1].nextWeek;
    }

    // Set weeks
    _weeks = weeks;
  }
}

class _DayTile extends StatelessWidget {
  final DateTime date;
  final void Function() onTap;
  final bool isSelected;

  const _DayTile({
    Key? key,
    required this.date,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
          onTap: () => onTap(),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
              borderRadius: BorderRadius.circular(16),
            ),
            child: DefaultTextStyle(
              style: TextStyle(
                color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat.E().format(date)),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text('${date.day}', style: const TextStyle(fontSize: 26),),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}

class WeekTimelineController extends ChangeNotifier {
  final DateTime initialDate;
  late DateTime _selectedDate;

  WeekTimelineController({
    required this.initialDate,
  }) : _selectedDate = _normalizeDate(initialDate);

  // PUBLIC API

  DateTime get selectedDate => _selectedDate;

  set selectedDate(DateTime date) {
    _selectedDate = _normalizeDate(date);
    notifyListeners();
  }
}

// UTILITY

/// Checks if the passed dates are equal, regardless of the time of the day.
bool _areDatesEqual(DateTime date1, DateTime date2) {
  if (date1.day == date2.day &&
      date1.month == date2.month &&
      date1.year == date2.year) {
    return true;
  } else {
    return false;
  }
}

class _Week {
  final DateTime weekFirstDate;

  /// Creates a new Week instance.
  ///
  /// A week is composed of 7 dates starting from [weekFirstDate].
  ///
  /// [weekFirstDate] should be a Monday.
  _Week({
    required DateTime weekFirstDate,
  }) : weekFirstDate = _normalizeDate(weekFirstDate);

  /// Creates a new Week instance where the first day is the previous Monday
  /// with respect to the passed [date] or the passed [date] itself if it is a
  /// Monday.
  _Week.fromPreviousMondayOf({
    required DateTime date,
  }) : weekFirstDate = _previousMondayOf(date);

  List<DateTime> get weekDates {
    return List.generate(7, (index) => weekFirstDate.add(Duration(days: index)));
  }

  /// Whether or not this week contains the specified date.
  bool contains(DateTime date) {
    for (final weekDate in weekDates) {
      if (weekDate.day == date.day &&
          weekDate.month == date.month &&
          weekDate.year == date.year) {
        return true;
      }
    }
    return false;
  }

  _Week get previousWeek {
    return _Week.fromPreviousMondayOf(
        date: weekFirstDate.subtract(const Duration(days: 7)));
  }

  _Week get nextWeek {
    return _Week.fromPreviousMondayOf(
        date: weekFirstDate.add(const Duration(days: 7)));
  }
}

/// Returns the previous Monday with respect to the specified [date] or the
/// specified [date] if it is already a Monday.
DateTime _previousMondayOf(DateTime date) {
  date = _normalizeDate(date);
  var dateDayName = DateFormat.EEEE().format(date);
  while(dateDayName != 'Monday') {
    date = date.subtract(const Duration(days: 1));
    dateDayName = DateFormat.EEEE().format(date);
  }
  return _normalizeDate(date);
}

DateTimeRange _normalizeDateRange(DateTimeRange dateRange) {
  return DateTimeRange(
    start: _normalizeDate(dateRange.start),
    end: _normalizeDate(dateRange.end),
  );
}

/// Returns the normalized date.
///
/// This is useful to avoid potential errors with daylight saving time.
DateTime _normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day, 12);
}
