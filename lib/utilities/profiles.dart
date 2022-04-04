import 'package:flutter/material.dart';
import 'package:uniud_timetable_app/apis/uniud_timetable_api.dart';

class Profiles extends ChangeNotifier {
  final Set<Profile> _profiles = {};

  /// All the lessons from all profiles.
  ///
  /// These are guaranteed to be sorted by [CourseLesson.startDateTime] using [List.sort].
  final List<CourseLesson> _allLessons = [];

  List<Profile> get profiles => _profiles.toList();

  /// Loads saved profiles from disk.
  Future<void> loadProfiles() async {
    // TODO implement
  }

  void addProfile(Profile profile) {
    _profiles.add(profile);
    _updateAllLessons();
    notifyListeners();
  }

  /// Deletes the profile based on the == operator.
  void deleteProfile(Profile profile) {
    _profiles.remove(profile);
    _updateAllLessons();
    notifyListeners();
  }

  /// Updates [_allLessons] list when a profile is added or removed.
  void _updateAllLessons() {
    _allLessons.clear();
    for (final profile in _profiles) {
      for (final course in profile.courses) {
        _allLessons.addAll(course.lessons);
      }
    }
    _allLessons.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
  }

  /// All the lessons from all profiles.
  ///
  /// These are guaranteed to be sorted by [CourseLesson.startDateTime] using [List.sort].
  List<CourseLesson> get allLessons => _allLessons;

  // TODO OPTIMIZATION implement search with binary search
  /// Return all lessons for the specified [day].
  ///
  /// These are guaranteed to be sorted by [CourseLesson.startDateTime] using [List.sort].
  List<CourseLesson> allLessonsOf({required DateTime day}) {
    List<CourseLesson> result = [];
    for (final lesson in _allLessons) {
      // The order of comparison is for optimization (short-circuit evaluation)
      if (lesson.startDateTime.day == day.day &&
          lesson.startDateTime.month == day.month &&
          lesson.startDateTime.year == day.year) {
        result.add(lesson);
      }
    }
    return result;
  }
}
