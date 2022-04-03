import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key? key}) : super(key: key);

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  @override
  Widget build(BuildContext context) {
    var selectedDayProvider = Provider.of<ValueNotifier<DateTime>>(context);
    return Column(
      children: [
        CalendarTimeline(
          initialDate: selectedDayProvider.value,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          onDateSelected: (dateTime) {
            if (dateTime != null) {
              selectedDayProvider.value = dateTime;
            }
          }, // TODO onDateSelected change the timetabled displayed
          leftMargin: 60,
          monthColor: Theme.of(context).colorScheme.secondary,
          dayColor: Theme.of(context).colorScheme.secondary,
          activeDayColor: Theme.of(context).colorScheme.onPrimaryContainer,
          activeBackgroundDayColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        Expanded(
          child: Center(
            child: ElevatedButton(
              child: const Text(
                'Test button',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => selectedDayProvider.value = DateTime.now(),
            ),
          ),
        ),
      ],
    );
  }
}
