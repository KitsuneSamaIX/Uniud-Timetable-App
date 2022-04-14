import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekTimeline extends StatefulWidget {
  final WeekTimelineController controller;
  final void Function(DateTime date)? onDateSelected;

  const WeekTimeline({
    Key? key,
    required this.controller,
    this.onDateSelected,
  }) : super(key: key);

  @override
  State<WeekTimeline> createState() => _WeekTimelineState();
}

class _WeekTimelineState extends State<WeekTimeline> with AutomaticKeepAliveClientMixin {
  static const int _viewableWeeksRadius = 1000;
  static const int _totalViewableWeeks = (_viewableWeeksRadius * 2) + 1;
  final int _currentWeekIndex = (_totalViewableWeeks / 2).floor();

  final DateTime _currentDate = _normalizeDate(DateTime.now());

  late final _pageController = PageController(initialPage: _currentWeekIndex);

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_dateSelectionListener);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 10),
      child: Column(
        children: [
          _WeekTimelineHeader(week: _Week.fromPreviousMondayOf(
              date: widget.controller.selectedDate)),
          SizedBox(
            height: 70,
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index) =>
                  widget.controller.gotoDate(_getWeekBy(index: index)
                      .weekDates[widget.controller.selectedDate.weekday-1]),
              itemBuilder: (context, index) {
                final selectedWeek = _getWeekBy(index: index);
                final selectedWeekDates = selectedWeek.weekDates;
                return Row(
                  children: List.generate(selectedWeekDates.length, (j) {
                    return _DayTile(
                      date: selectedWeekDates[j],
                      isSelected: _areDatesEqual(
                          selectedWeekDates[j], widget.controller.selectedDate),
                      onTap: () =>
                          widget.controller.gotoDate(selectedWeekDates[j]),
                    );
                  }),
                );
              },
            ),
          ),
        ],
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
      widget.onDateSelected!(widget.controller.selectedDate);
    }
  }

  /// Lazily generates the week from the index.
  _Week _getWeekBy({required int index}) {
    // Get current week
    final currentWeek = _Week.fromPreviousMondayOf(date: _currentDate);

    // From current week's first date compute the required week
    final distanceInWeeks = index - _currentWeekIndex;
    final distanceInDays = distanceInWeeks * 7; // A week has 7 days
    final requiredWeek = _Week.fromPreviousMondayOf(
        date: currentWeek.weekFirstDate.add(Duration(days: distanceInDays)));

    return requiredWeek;
  }
}

class _WeekTimelineHeader extends StatelessWidget {
  final _Week week;

  const _WeekTimelineHeader({
    Key? key,
    required this.week,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_rounded, size: 18,),
          const SizedBox(width: 10,),
          const Text('Week '),
          Text('${week.weekFirstDate.day}-${week.weekDates.last.day} '),
          Text(DateFormat.MMMM().format(week.weekDates.last)),
        ],
      ),
    );
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
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
              borderRadius: BorderRadius.circular(14),
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
                    child: Text('${date.day}', style: const TextStyle(fontSize: 27),),
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

  /// The selected date.
  DateTime get selectedDate => _selectedDate;

  void gotoDate(DateTime date) {
    date = _normalizeDate(date);
    // This check could prevent undesired loops and also improves performance
    if (!_areDatesEqual(date, _selectedDate)) {
      _selectedDate = date;
      notifyListeners();
    }
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

  /// Creates a new Week instance where the first day is the previous Monday
  /// with respect to the passed [date] or the passed [date] itself if it is
  /// already Monday.
  ///
  /// A week is composed of 7 days starting from [weekFirstDate].
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
  return date;
}

/// Returns the normalized date.
///
/// This is useful to avoid potential errors with daylight saving time.
DateTime _normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day, 12);
}
