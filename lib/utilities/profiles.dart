import 'package:flutter/material.dart';
import 'package:uniud_timetable_app/apis/uniud_timetable_api.dart';

class Profiles extends ChangeNotifier {
  final Set<Profile> _profiles = {};

  List<Profile> get profiles => _profiles.toList();

  /// Loads saved profiles from disk.
  Future<void> loadProfiles() async { // TODO implement

  }

  void addProfile(Profile profile) {
    _profiles.add(profile);
    notifyListeners();
  }

  /// Deletes the profile based on the == operator.
  void deleteProfile(Profile profile) {
    _profiles.remove(profile);
    notifyListeners();
  }

// TODO add a function to get all courses from all profiles in a list, then
//    for each course i will sort the lessons based on the DateTime of the lesson
//    (ONLY ONE TIME SORT is needed, and maybe i could add a property to set
//    when the lessons of a course are sorted), with the lessons sorted i will be
//    able to use a binary search over the sorted list thus improving the search time
//    a lot.
//    I could also create a single list with ALL the lessons, sort that list one time,
//    and then apply binary search on that list.
}
