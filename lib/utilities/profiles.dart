import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uniud_timetable_app/models/profile_models.dart';

class Profiles extends ChangeNotifier {
  // Private attributes
  static const _fileName = 'profiles.json';

  var _profilesWrapper = ProfilesWrapper({});

  /// All the lessons from all profiles.
  ///
  /// These are guaranteed to be sorted by [CourseLesson.startDateTime] using [List.sort].
  final List<CourseLesson> _allLessons = [];

  // PUBLIC API ----------------------------------------------------------------

  /// Returns a new List containing all the profiles.
  List<Profile> get profiles => _profilesWrapper.profiles.toList();

  /// Returns all the lessons from all profiles.
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

  /// Loads saved profiles from disk.
  Future<void> loadProfiles() async {
    if (kIsWeb) {
      // TODO
      throw UnimplementedError();
    } else {
      final file = await _localFile;
      final fileExists = await file.exists();
      if (fileExists) {
        final profilesJson = await file.readAsString();
        _profilesWrapper = ProfilesWrapper.fromJson(
            jsonDecode(profilesJson) as Map<String, dynamic>);
      } else {
        return;
      }
    }

    // Update
    _updateAllLessons();
    notifyListeners();
  }

  /// Saves profiles on disk.
  Future<void> saveProfiles() async {
    if (kIsWeb) {
      // TODO
      throw UnimplementedError();
    } else {
      final file = await _localFile;
      file.writeAsString(jsonEncode(_profilesWrapper.toJson()));
    }
  }

  /// Adds a new [profile] to the internal Set.
  void addProfile(Profile profile) {
    _profilesWrapper.profiles.add(profile);

    // Update
    _updateAllLessons();
    notifyListeners();
    saveProfiles();
  }

  /// Deletes the specified [profile] from the Set,
  /// (deletion is based on == operator).
  void deleteProfile(Profile profile) {
    _profilesWrapper.profiles.remove(profile);

    // Update
    _updateAllLessons();
    notifyListeners();
    saveProfiles();
  }

  // MANAGEMENT ----------------------------------------------------------------

  /// Updates [_allLessons] list when a profiles are modified.
  void _updateAllLessons() {
    _allLessons.clear();
    for (final profile in _profilesWrapper.profiles) {
      for (final course in profile.courses) {
        // Keep a reference to the parent course
        final lessonsIterWithParentRef = course.lessons.map((e) {
          e.course = course;
          return e;
        });
        _allLessons.addAll(lessonsIterWithParentRef);
      }
    }
    _allLessons.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
  }

  /// Returns the local file containing the saved profiles data.
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/$_fileName');
  }
}
