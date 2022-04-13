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
  final _weekTimelineController = WeekTimelineController(initialDate: DateTime.now());

  @override
  Widget build(BuildContext context) {
    final timetableManagerProvider = Provider.of<TimetableManager>(context);
    final profilesProvider = Provider.of<Profiles>(context);

    return Column(
      children: [
        WeekTimeline(
          controller: _weekTimelineController,
        ),
        Expanded(
          child: PageView.builder(
            controller: timetableManagerProvider.lessonsPageController,
            onPageChanged: (index) {
              // timetableManagerProvider.gotoIndex(index); TODO convert index to date
            },
            itemBuilder: (context, index) {
              final selectedDayLessons = profilesProvider.allLessonsOf(
                  day: timetableManagerProvider.selectedDate); // TODO use index here
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
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _weekTimelineController.dispose();
    super.dispose();
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
    final timeSlotString =
        '${lesson.startDateTime.hour}:'
        '${lesson.startDateTime.minute} -> '
        '${lesson.endDateTime.hour}:'
        '${lesson.endDateTime.minute}';

    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: SizedBox(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    const Icon(Icons.access_time_rounded, size: 18),
                    const SizedBox(width: 8),
                    Text(timeSlotString),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.place_outlined, size: 18),
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
    );
  }
}
