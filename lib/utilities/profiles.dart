import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniud_timetable_app/models/profile_models.dart';

class Profiles extends ChangeNotifier {
  // Private attributes
  static const _fileName = 'profiles.json';

  var _profilesWrapper = ProfilesWrapper({});

  /// All courses from all profiles.
  ///
  /// These are guaranteed to have no duplicate courses.
  final Set<Course> _allCourses = {};

  /// All lessons from all courses from all profiles.
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

  /// Return all lessons for the specified [date].
  ///
  /// These are guaranteed to be sorted by [CourseLesson.startDateTime] using [List.sort].
  List<CourseLesson> allLessonsOf({required DateTime date}) {
    List<CourseLesson> result = [];
    for (final lesson in _allLessons) {
      // The order of comparison is for optimization (short-circuit evaluation)
      if (lesson.startDateTime.day == date.day &&
          lesson.startDateTime.month == date.month &&
          lesson.startDateTime.year == date.year) {
        result.add(lesson);
      }
    }
    return result;
  }

  /// Loads saved profiles from disk.
  Future<void> loadProfiles() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final profilesJson = prefs.getString(_fileName);
      if (profilesJson != null) {
        _profilesWrapper = ProfilesWrapper.fromJson(
            jsonDecode(profilesJson) as Map<String, dynamic>);
      } else {
        return;
      }
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
    _updateInternalState();
    notifyListeners();
  }

  /// Saves profiles on disk.
  Future<void> saveProfiles() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_fileName, jsonEncode(_profilesWrapper.toJson()));
    } else {
      final file = await _localFile;
      file.writeAsString(jsonEncode(_profilesWrapper.toJson()));
    }
  }

  /// Adds a new [profile] to the internal Set.
  void addProfile(Profile profile) {
    _profilesWrapper.profiles.add(profile);

    // Update
    _updateInternalState();
    notifyListeners();
    saveProfiles();
  }

  /// Deletes the specified [profile] from the Set,
  /// (deletion is based on == operator).
  void deleteProfile(Profile profile) {
    _profilesWrapper.profiles.remove(profile);

    // Update
    _updateInternalState();
    notifyListeners();
    saveProfiles();
  }

  // MANAGEMENT ----------------------------------------------------------------

  /// Updates the internal state of this istance when profiles are modified.
  ///
  /// In particular it:
  /// - updates [_allCourses] Set.
  /// - updates [_allLessons] List.
  void _updateInternalState() {
    // Clear previous courses
    _allCourses.clear();
    // Clear previous lessons
    _allLessons.clear();

    // Gather all courses inside a Set to remove possible duplicates
    for (final profile in _profilesWrapper.profiles) {
      _allCourses.addAll(profile.courses);
    }

    // Update all lessons keeping a reference to the parent course
    for (final course in _allCourses) {
      // Keep a reference to the parent course
      final lessonsIterWithParentRef = course.lessons.map((e) {
        e.course = course;
        return e;
      });
      _allLessons.addAll(lessonsIterWithParentRef);
    }

    // Sort all lessons by their start DateTime
    _allLessons.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
  }

  /// Returns the local file containing the saved profiles data.
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/$_fileName');
  }
}
