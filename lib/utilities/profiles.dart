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
}
