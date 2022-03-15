import 'package:test/test.dart';
import 'package:uniud_timetable_app/uniud_timetable_api.dart';
import 'package:xml/xml.dart';

void main() {
  Map<String, dynamic> rememberSelection = {};

  test("Retrieve the degrees index from Uniud's API.", () async {
    final api = UniudTimetableAPI();

    var degreesRawIndex = await api.getDegreesRawIndex();

    var departments = api.getDepartments(degreesRawIndex);

    for (final department in departments) {
      print(department.name);

      if (department.name == 'Dipartimento di Scienze Matematiche, Informatiche e Fisiche') {
        print('');
        var degreeTypes = api.getDegreeTypes(department);

        for (final degreeType in degreeTypes) {
          print(degreeType.name);

          if (degreeType.name == 'Laurea') {
            print('');
            var degrees = api.getDegrees(degreeType);

            for (final degree in degrees) {
              print(degree.name);

              if (degree.name == 'INFORMATICA') {
                print('');
                var periods = api.getPeriods(degree);

                for (final period in periods) {
                  print(period.name);
                  rememberSelection['degree'] = degree;
                  rememberSelection['period'] = period;
                }
                break;
              }
            }
            break;
          }
        }
        break;
      }
    }
  });

  test("Retrieve a degree course from Uniud's API.", () async {
    final api = UniudTimetableAPI();

    var courseDescriptors =
      await api.getCourseDescriptors(
        rememberSelection['degree'] as Degree,
        rememberSelection['period'] as Period
      );

    print('\n\n');
    for (final element in courseDescriptors) {
      print(element.name);
      if (element.name == 'ANALISI MATEMATICA') {
        rememberSelection['courseDescriptor'] = element;
      }
    }
  });

  test("Retrieve a course info from Uniud's API.", () async {
    final api = UniudTimetableAPI();

    var course =
      await api.getCourse(
        // CourseDescriptor(
        //     'Name placeholder',
        //     '0',
        //     '2021/PS_MA07139_766_1_S2.xml'
        // )
        rememberSelection['courseDescriptor'] as CourseDescriptor
      );

    print('\n\n\n');
    print(course.name);
  });
}
