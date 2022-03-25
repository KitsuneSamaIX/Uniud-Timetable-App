import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key? key}) : super(key: key);

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  var _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CalendarTimeline(
          initialDate: _selectedDay,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          onDateSelected: (dateTime) {}, // TODO onDateSelected callback
          leftMargin: 60,
          monthColor: Theme.of(context).colorScheme.secondary,
          dayColor: Theme.of(context).colorScheme.secondary,
          activeDayColor: Theme.of(context).colorScheme.primary,
          activeBackgroundDayColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Hello Fellow Student!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
