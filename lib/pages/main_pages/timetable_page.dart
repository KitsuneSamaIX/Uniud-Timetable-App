import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uniud_timetable_app/utilities/profiles.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key? key}) : super(key: key);

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  @override
  Widget build(BuildContext context) {
    final selectedDayProvider = Provider.of<ValueNotifier<DateTime>>(context);
    final profilesProvider = Provider.of<Profiles>(context);
    final selectedDayLessons = profilesProvider.allLessonsOf(day: selectedDayProvider.value);
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
          },
          leftMargin: 60,
          monthColor: Theme.of(context).colorScheme.secondary,
          dayColor: Theme.of(context).colorScheme.secondary,
          activeDayColor: Theme.of(context).colorScheme.onPrimaryContainer,
          activeBackgroundDayColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        Expanded(
          child: ListView.separated(
            itemCount: selectedDayLessons.length,
            itemBuilder: (context, index) {
              final timeSlotString =
                  '${selectedDayLessons[index].startDateTime.hour}:'
                  '${selectedDayLessons[index].startDateTime.minute} -> '
                  '${selectedDayLessons[index].endDateTime.hour}:'
                  '${selectedDayLessons[index].endDateTime.minute}';
              return ListTile(
                title: Text(selectedDayLessons[index].course!.name),
                subtitle: Text(timeSlotString),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          ),
        ),
      ],
    );
  }
}
