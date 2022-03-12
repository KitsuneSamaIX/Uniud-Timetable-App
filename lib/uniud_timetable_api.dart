import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class UniudTimetableAPI {
  // API Endpoints
  final _degreesIndexEndpoint = Uri.parse('https://planner.uniud.it/PortaleStudenti/api_profilo_aa_scuola_tipo_cdl_pd.php');
  final _degreeCoursesEndpoint = Uri.parse('https://planner.uniud.it/PortaleStudenti/api_profilo_lista_insegnamenti.php');
  final _courseInfoEndpoint = Uri.parse('https://planner.uniud.it/PortaleStudenti//App/zipped.php');

  UniudTimetableAPI();

  /// Gets the raw Degrees Index in JSON format from the Uniud REST API.
  /// The hiearchy of the data inside the returned JSON will be:
  /// Department -> Type of Degree -> Degree -> Period
  /// Class objects will be instantiated only when necessary during the
  /// traversing of the data hierarchy: lazy approach.
  Future<DegreesRawIndex> getDegreesRawIndex() async {
    var response = await http.get(_degreesIndexEndpoint);

    if (response.statusCode == 200) {
      return DegreesRawIndex(jsonDecode(response.body));
    } else {
      throw Exception('A problem occurred while downloading the degrees index.');
    }
  }

  List<Department> getDepartments(DegreesRawIndex degreesRawIndex) {
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

  List<DegreeType> getDegreeTypes(Department department) {
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

  List<Degree> getDegrees(DegreeType degreeType) {
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

  List<Period> getPeriods(Degree degree) {
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

  Future<List<CourseDescriptor>> getCourseDescriptors(Degree degree, Period period) async {
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

  Future<Course> getCourse(CourseDescriptor courseDescriptor) async {
    final enpoint = Uri.https(
        _courseInfoEndpoint.authority,
        _courseInfoEndpoint.path,
        {
          'file': courseDescriptor.fileId
        }
    );

    var response = await http.get(enpoint);

    if (response.statusCode == 200) {
      // TODO parse the xml returned by this response, it contains all the course's data
      // TODO XML library is already download, you it to parse
      return ; // TODO return the result
    } else {
      throw Exception("A problem occurred while downloading the course's info.");
    }
  }
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

class Department {
  final String name;
  final String id;
  final dynamic degreeTypesRawData;

  Department(this.name, this.id, this.degreeTypesRawData);
}

class DegreeType {
  final String name;
  final String id;
  final dynamic degreesRawData;

  DegreeType(this.name, this.id, this.degreesRawData);
}

class Degree {
  final String name;
  final String id;
  final dynamic periodsRawData;

  Degree(this.name, this.id, this.periodsRawData);
}

class Period {
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
  final List<CourseLesson> lessons;

  Course(this.name, this.credits, this.lessons);
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
