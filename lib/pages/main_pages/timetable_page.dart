import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uniud_timetable_app/custom_widgets/week_timeline.dart';
import 'package:uniud_timetable_app/utilities/profiles.dart';
import 'package:uniud_timetable_app/utilities/timetable_manager.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key? key}) : super(key: key);

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  @override
  Widget build(BuildContext context) {
    final timetableManagerProvider = Provider.of<TimetableManager>(context);
    final profilesProvider = Provider.of<Profiles>(context);

    return Column(
      children: [
        // CalendarTimeline(
        //   initialDate: timetableManagerProvider.selectedDay,
        //   firstDate: timetableManagerProvider.firstDay,
        //   lastDate: timetableManagerProvider.lastDay,
        //   onDateSelected: (day) {
        //     if (day != null) {
        //       timetableManagerProvider.gotoDay(day);
        //     }
        //   },
        //   leftMargin: 60,
        //   monthColor: Theme.of(context).colorScheme.secondary,
        //   dayColor: Theme.of(context).colorScheme.secondary,
        //   activeDayColor: Theme.of(context).colorScheme.onPrimaryContainer,
        //   activeBackgroundDayColor: Theme.of(context).colorScheme.primaryContainer,
        // ),
        WeekTimeline(
          controller: WeekTimelineController(initialDate: DateTime.now()),
        ),
        Expanded( // TODO try the Card() Widget
        child: PageView.builder(
            controller: timetableManagerProvider.pageController,
            onPageChanged: (index) {
              timetableManagerProvider.gotoIndex(index);
            },
            itemBuilder: (context, index) {
              final selectedDayLessons = profilesProvider.allLessonsOf(
                  day: timetableManagerProvider.indexToDay(index));
              return ListView.separated(
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
              );
            },
          ),
        ),
      ],
    );
  }
}
