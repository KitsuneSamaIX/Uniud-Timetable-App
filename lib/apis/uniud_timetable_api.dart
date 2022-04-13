import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:uniud_timetable_app/models/profile_models.dart';
import 'package:xml/xml.dart';

class UniudTimetableAPI {
  // API Endpoints
  static final _degreesIndexEndpoint =  kIsWeb ? Uri.parse('https://uniud-timetable-app.herokuapp.com/PortaleStudenti/api_profilo_aa_scuola_tipo_cdl_pd.php')
      : Uri.parse('https://planner.uniud.it/PortaleStudenti/api_profilo_aa_scuola_tipo_cdl_pd.php');
  static final _degreeCoursesEndpoint = kIsWeb ? Uri.parse('https://uniud-timetable-app.herokuapp.com/PortaleStudenti/api_profilo_lista_insegnamenti.php')
      : Uri.parse('https://planner.uniud.it/PortaleStudenti/api_profilo_lista_insegnamenti.php');
  static final _courseInfoEndpoint = kIsWeb ? Uri.parse('https://uniud-timetable-app.herokuapp.com/PortaleStudenti//App/zipped.php')
      : Uri.parse('https://planner.uniud.it/PortaleStudenti//App/zipped.php');

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
                  courseDescriptor['docente'] as String,
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

        // Build the Professor object
        final courseProfessor = Professor(
            docProfessor.getAttribute('Nome')!,
            docProfessor.getAttribute('Cognome')!
        );
        courseProfessor.email = docProfessor.getAttribute('Mail1');
        courseProfessor.phone = docProfessor.getAttribute('Fisso');

        // Build the Course object
        final course = Course(
            docCourse.getAttribute('Nome')!,
            docCourse.getAttribute('Crediti')!,
            courseProfessor,
            []
        );

        // Build the CourseLesson objects and insert them into the Course object
        for (final child in docCalendar.findElements('Giorno')) {
          // Parse the date
          final rawDate = child.getAttribute('Data')!;
          final rawDateComps = rawDate.split('-');
          final date = DateTime(
              int.parse(rawDateComps[2]),
              int.parse(rawDateComps[1]),
              int.parse(rawDateComps[0])
          );

          // Parse the timeslot
          final rawStartTime = child.getAttribute('OraInizio')!;
          final rawStartTimeComps = rawStartTime.split(':');
          final rawEndTime = child.getAttribute('OraFine')!;
          final rawEndTimeComps = rawEndTime.split(':');

          final startDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            int.parse(rawStartTimeComps[0]),
            int.parse(rawStartTimeComps[1]),
          );

          final endDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            int.parse(rawEndTimeComps[0]),
            int.parse(rawEndTimeComps[1]),
          );

          course.lessons.add(
            CourseLesson(
              startDateTime,
              endDateTime,
              child.getAttribute('Sede')!,
              child.getAttribute('Aula')!,
            )
          );
        }

        // Return the Course object
        return course;

      } catch(e) {
        throw Exception("A problem occurred while parsing the course's xml data. ($e)");
      }
      
    } else {
      throw Exception("A problem occurred while downloading the course's info "
          "(response code: ${response.statusCode}).");
    }
  }
}

class ProfileBuilder {
  String? name;
  Department? department;
  DegreeType? degreeType;
  Degree? degree;
  Period? period;
  Set<CourseDescriptor>? courseDescriptors;
  Set<Course>? courses;
  
  Profile build() {
    try {
      return Profile(
        name!,
        department!.name,
        degreeType!.name,
        degree!.name,
        period!.name,
        courses!,
      );
    } catch(e) {
      throw StateError('The object cannot be built in the current state: $e');
    }
  }
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
  final String professor;
  final String credits;
  final String fileId;

  CourseDescriptor(this.name, this.professor, this.credits, this.fileId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseDescriptor &&
          runtimeType == other.runtimeType &&
          fileId == other.fileId;

  @override
  int get hashCode => fileId.hashCode;
}
