import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uniud_timetable_app/custom_widgets/week_timeline.dart';
import 'package:uniud_timetable_app/models/profile_models.dart';
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
        WeekTimeline(
          controller: timetableManagerProvider.weekTimelineController,
          onDateSelected: (date) =>
              timetableManagerProvider.lessonsPageControllerAnimateToPage(
                  timetableManagerProvider.dateToLessonsPageIndex(date)),
        ),
        Expanded(
          child: PageView.builder(
            controller: timetableManagerProvider.lessonsPageController,
            onPageChanged: (index) {
              if (!timetableManagerProvider.lessonsPageControllerIsAnimatingToPage) {
                timetableManagerProvider.weekTimelineController.gotoDate(
                    timetableManagerProvider.lessonsPageIndexToDate(index));
              }
            },
            itemBuilder: (context, index) {
              final selectedDayLessons = profilesProvider.allLessonsOf(
                  date: timetableManagerProvider.lessonsPageIndexToDate(index));
              if (selectedDayLessons.isNotEmpty) {
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: selectedDayLessons.length,
                  itemBuilder: (context, index) {
                    return _LessonCard(lesson: selectedDayLessons[index]);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 8);
                  },
                );
              } else {
                return DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                  child: Align(
                    alignment: const Alignment(0, -0.6),
                    child: SizedBox(
                      width: 250,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          profilesProvider.profiles.isNotEmpty
                              ? Icon(Icons.tag_faces_outlined, size: 60, color: Theme.of(context).colorScheme.secondary,)
                              : Icon(Icons.inbox_rounded, size: 60, color: Theme.of(context).colorScheme.secondary,),
                          const SizedBox(height: 16,),
                          profilesProvider.profiles.isNotEmpty
                              ? const Text('Nothing to show here.\nEnjoy your free time!', textAlign: TextAlign.center,)
                              : const Text("Hello fellow student!\nI see that you "
                              "haven't created any profiles yet, you can create one "
                              "from the 'Profiles' page.", textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class _LessonCard extends StatelessWidget {
  final CourseLesson lesson;

  const _LessonCard({
    Key? key,
    required this.lesson,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final startTimeString = '${lesson.startDateTime.hour}:'
        '${lesson.startDateTime.minute}';
    final endTimeString = '${lesson.endDateTime.hour}:'
        '${lesson.endDateTime.minute}';

    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: SizedBox(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: IconTheme(
            data: IconThemeData(
              size: 18,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            child: DefaultTextStyle(
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontSize: 14.5,
                overflow: TextOverflow.ellipsis,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lesson.course!.name + '\n',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded),
                      const SizedBox(width: 8),
                      Text('$startTimeString '),
                      Icon(Icons.arrow_forward_rounded,
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      Text(' $endTimeString'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.place_outlined),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('${lesson.room}, ${lesson.building}'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
