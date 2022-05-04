import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uniud_timetable_app/common/common.dart';
import 'package:uniud_timetable_app/custom_widgets/week_timeline.dart';
import 'package:uniud_timetable_app/models/profile_models.dart';
import 'package:uniud_timetable_app/utilities/profiles.dart';
import 'package:uniud_timetable_app/utilities/timetable_manager.dart';

class TimetablePage extends StatelessWidget {
  const TimetablePage({Key? key}) : super(key: key);

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
            itemCount: timetableManagerProvider.totalViewableDates,
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

    return GestureDetector(
      onTap: () =>
          Navigator.of(context).push(_HeroPopupRoute<void>(
                  (context) => _LessonInfoPopup(lesson: lesson))),
      child: Hero(
        tag: lesson,
        child: Card(
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
        ),
      ),
    );
  }
}

class _HeroPopupRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;

  _HeroPopupRoute(this.builder) : super();

  @override
  bool get opaque => false;

  @override
  Color? get barrierColor => Colors.black54;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Popup Barrier';

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 220);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }
}

class _LessonInfoPopup extends StatelessWidget {
  final CourseLesson lesson;

  const _LessonInfoPopup({
    Key? key,
    required this.lesson,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final startTimeString = '${lesson.startDateTime.hour}:'
        '${lesson.startDateTime.minute}';
    final endTimeString = '${lesson.endDateTime.hour}:'
        '${lesson.endDateTime.minute}';

    return Center(
      child: Hero(
        tag: lesson,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          color: Theme.of(context).colorScheme.secondaryContainer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: SizedBox(
            height: 480,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.course!.name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    _LessonInfoGroup(
                      title: const Text('Lesson'),
                      children: [
                        _LessonInfoElement(
                          leading: const Icon(Icons.access_time_rounded),
                          title: Row(
                            children: [
                              Text('$startTimeString '),
                              Icon(Icons.arrow_forward_rounded,
                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                              ),
                              Text(' $endTimeString'),
                            ],
                          ),
                        ),
                        _LessonInfoElement(
                          leading: const Icon(Icons.place_outlined),
                          title: Text(
                            '${lesson.room}, ${lesson.building}',
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                    _LessonInfoGroup(
                      title: const Text('Course'),
                      children: [
                        _LessonInfoElement(
                          leading: const Icon(Icons.drive_file_rename_outline_rounded),
                          title: Text(
                            lesson.course!.name,
                            maxLines: 3,
                          ),
                        ),
                        _LessonInfoElement(
                          leading: Text(
                            'CFU',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          title: Text(
                            lesson.course!.credits,
                          ),
                        ),
                      ],
                    ),
                    _LessonInfoGroup(
                      title: const Text('Professor'),
                      children: [
                        _LessonInfoElement(
                          leading: Text(
                            'Prof.',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          title: Text(
                            '${lesson.course!.professor.name} '
                                '${lesson.course!.professor.surname}',
                          ),
                        ),
                        _LessonInfoElement(
                          leading: const Icon(Icons.mail_outline_rounded),
                          title: SelectableText(
                            '${lesson.course!.professor.email}',
                          ),
                        ),
                        _LessonInfoElement(
                          leading: const Icon(Icons.phone),
                          title: SelectableText(
                            '${lesson.course!.professor.phone}',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LessonInfoGroup extends StatelessWidget {
  final Widget? title;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const _LessonInfoGroup({
    Key? key,
    this.title,
    required this.children,
    this.padding
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Prepare column elements
    final elements = <Widget>[];
    if (title != null) {
      elements.add(
        DefaultTextStyle(
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            fontSize: 16,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
          ),
          child: title!,
        ),
      );
      elements.add(const SizedBox(height: 14,));
    }
    elements.addAll(separateWidgets(
      widgets: children,
      separator: const SizedBox(height: 14,),
    ));

    return Padding(
      padding: padding != null ? padding! : const EdgeInsets.only(top: 8, bottom: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: elements,
      ),
    );
  }
}

class _LessonInfoElement extends StatelessWidget {
  final Widget? leading;
  final Widget title;

  const _LessonInfoElement({
    Key? key,
    this.leading,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Prepare row elements
    final elements = <Widget>[];
    if (leading != null) {
      elements.add(leading!);
      elements.add(const SizedBox(width: 8));
    }
    elements.add(Flexible(child: title));

    return IconTheme(
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: elements,
        ),
      ),
    );
  }
}
