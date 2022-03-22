import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class UniudTimetableAPI {
  // API Endpoints
  static final _degreesIndexEndpoint = Uri.parse('https://planner.uniud.it/PortaleStudenti/api_profilo_aa_scuola_tipo_cdl_pd.php');
  static final _degreeCoursesEndpoint = Uri.parse('https://planner.uniud.it/PortaleStudenti/api_profilo_lista_insegnamenti.php');
  static final _courseInfoEndpoint = Uri.parse('https://planner.uniud.it/PortaleStudenti//App/zipped.php');

  UniudTimetableAPI();

  /// Gets the raw Degrees Index in JSON format from the Uniud REST API.
  /// The hiearchy of the data inside the returned JSON will be:
  /// Department -> Type of Degree -> Degree -> Period
  /// Class objects will be instantiated only when necessary during the
  /// traversing of the data hierarchy: lazy approach.
  static Future<DegreesRawIndex> getDegreesRawIndex() async {
    var response = await http.get(_degreesIndexEndpoint);

    if (response.statusCode == 200) {
      return DegreesRawIndex(jsonDecode(response.body));
    } else {
      throw Exception('A problem occurred while downloading the degrees index '
          '(response code: ${response.statusCode}).');
    }
  }

  static List<Department> getDepartments(DegreesRawIndex degreesRawIndex) {
    try {
      List<Department> departments = [];
      for (final department in degreesRawIndex.index as List<dynamic>) {
        departments.add(
            Department(
                department['label'] as String,
                department['valore'] as String,
                department['elenco_lauree']
            )
        );
      }
      return departments;
    } catch(e) {
      print(e);
      return [];
    }
  }

  static List<DegreeType> getDegreeTypes(Department department) {
    try {
      List<DegreeType> degreeTypes = [];
      for (final degreeType in department.degreeTypesRawData as List<dynamic>) {
        degreeTypes.add(
            DegreeType(
                degreeType['tipo'] as String,
                degreeType['valore'] as String,
                degreeType['elenco_cdl']
            )
        );
      }
      return degreeTypes;
    } catch(e) {
      print(e);
      return [];
    }
  }

  static List<Degree> getDegrees(DegreeType degreeType) {
    try {
      List<Degree> degrees = [];
      for (final degree in degreeType.degreesRawData as List<dynamic>) {
        degrees.add(
            Degree(
                degree['label'] as String,
                degree['valore'] as String,
                degree['pub_periodi']
            )
        );
      }
      return degrees;
    } catch(e) {
      print(e);
      return [];
    }
  }

  static List<Period> getPeriods(Degree degree) {
    try {
      List<Period> periods = [];
      for (final period in degree.periodsRawData as List<dynamic>) {
        periods.add(
            Period(
                period['label'] as String,
                period['id'] as String
            )
        );
      }
      return periods;
    } catch(e) {
      print(e);
      return [];
    }
  }

  static Future<List<CourseDescriptor>> getCourseDescriptors(Degree degree, Period period) async {
    final enpoint = Uri.https(
        _degreeCoursesEndpoint.authority,
        _degreeCoursesEndpoint.path,
        {
          'cdl': degree.id,
          'periodo_didattico': period.id
        }
    );

    var response = await http.get(enpoint);

    if (response.statusCode == 200) {
      try {
        List<CourseDescriptor> courseDescriptors = [];
        for (final courseDescriptor in jsonDecode(response.body) as List<dynamic>) {
          courseDescriptors.add(
              CourseDescriptor(
                  courseDescriptor['nome'] as String,
                  courseDescriptor['crediti'] as String,
                  courseDescriptor['file'] as String
              )
          );
        }
        return courseDescriptors;
      } catch(e) {
        print(e);
        return [];
      }

    } else {
      throw Exception("A problem occurred while downloading the degree's courses.");
    }
  }

  static Future<Course> getCourse(CourseDescriptor courseDescriptor) async {
    final enpoint = Uri.https(
        _courseInfoEndpoint.authority,
        _courseInfoEndpoint.path,
        {
          'file': courseDescriptor.fileId
        }
    );

    var response = await http.get(enpoint);

    if (response.statusCode == 200) {
      // Try to parse the xml
      try {
        final docRoot = XmlDocument.parse(response.body);
        final docTimetable = docRoot.getElement('Orario')!;
        final docCourse = docTimetable.getElement('Insegnamento')!;
        final docProfessor = docCourse.getElement('DocenteTitolare')!;
        final docCalendar = docCourse.getElement('CalendarioLezioni')!;

        final List<CourseLesson> courseLessons = [];
        for (final child in docCalendar.findElements('Giorno')) {
          // Parse the date
          final rawDate = child.getAttribute('Data')!;
          final rawDateComps = rawDate.split('-');
          final lessonDate = DateTime(
              int.parse(rawDateComps[2]),
              int.parse(rawDateComps[1]),
              int.parse(rawDateComps[0])
          );
          // Parse the timeslot
          final rawStartTime = child.getAttribute('OraInizio')!;
          final rawStartTimeComps = rawStartTime.split(':');
          final rawEndTime = child.getAttribute('OraFine')!;
          final rawEndTimeComps = rawEndTime.split(':');
          final lessonTimeslot = TimeSlot(
              TimeOfDay(
                  hour: int.parse(rawStartTimeComps[0]),
                  minute: int.parse(rawStartTimeComps[1])
              ),
              TimeOfDay(
                  hour: int.parse(rawEndTimeComps[0]),
                  minute: int.parse(rawEndTimeComps[1])
              )
          );

          courseLessons.add(
              CourseLesson(
                  lessonDate,
                  lessonTimeslot,
                  child.getAttribute('Aula')!,
                  child.getAttribute('Sede')!
              )
          );
        }

        // Build the Professor object
        final courseProfessor = Professor(
            docProfessor.getAttribute('Nome')!,
            docProfessor.getAttribute('Cognome')!
        );
        courseProfessor.email = docProfessor.getAttribute('Mail1');
        courseProfessor.phone = docProfessor.getAttribute('Fisso');

        // Build and return the Course object
        return Course(
            docCourse.getAttribute('Nome')!,
            docCourse.getAttribute('Crediti')!,
            courseProfessor,
            courseLessons
        );
      } catch(e) {
        throw Exception("A problem occurred while parsing the course's xml data. ($e)");
      }
      
    } else {
      throw Exception("A problem occurred while downloading the course's info "
          "(response code: ${response.statusCode}).");
    }
  }
}

abstract class NamedItem {
  String get name;
}

class Profile {
  final String departmentName;
  final String degreeTypeName;
  final String degreeName;
  final String periodName;
  final List<Course> courses;

  Profile(this.departmentName, this.degreeTypeName, this.degreeName,
      this.periodName, this.courses);
}

class DegreesRawIndex {
  final dynamic index;

  DegreesRawIndex(this.index);
}

class Department implements NamedItem {
  @override
  final String name;
  final String id;
  final dynamic degreeTypesRawData;

  Department(this.name, this.id, this.degreeTypesRawData);
}

class DegreeType implements NamedItem {
  @override
  final String name;
  final String id;
  final dynamic degreesRawData;

  DegreeType(this.name, this.id, this.degreesRawData);
}

class Degree implements NamedItem {
  @override
  final String name;
  final String id;
  final dynamic periodsRawData;

  Degree(this.name, this.id, this.periodsRawData);
}

class Period implements NamedItem {
  @override
  final String name;
  final String id;

  Period(this.name, this.id);
}

class CourseDescriptor {
  final String name;
  final String credits;
  final String fileId;

  CourseDescriptor(this.name, this.credits, this.fileId);
}

class Course {
  final String name;
  final String credits;
  final Professor professor;
  final List<CourseLesson> lessons;

  Course(this.name, this.credits, this.professor, this.lessons);
}

class CourseLesson {
  final DateTime date;
  final TimeSlot timeSlot;
  final String building;
  final String room;

  CourseLesson(this.date, this.timeSlot, this.building, this.room);
}

class TimeSlot {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  TimeSlot(this.startTime, this.endTime);
}

class Professor {
  final String name;
  final String surname;
  String? email;
  String? phone;

  Professor(this.name, this.surname);
}
