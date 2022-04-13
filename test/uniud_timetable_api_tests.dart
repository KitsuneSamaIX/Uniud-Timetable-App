import 'package:test/test.dart';
import 'package:uniud_timetable_app/apis/uniud_timetable_api.dart';

void main() {
  Map<String, dynamic> rememberSelection = {};

  test("Retrieve the degrees index from Uniud's API.", () async {
    var degreesRawIndex = await UniudTimetableAPI.getDegreesRawIndex();

    var departments = UniudTimetableAPI.getDepartments(degreesRawIndex);

    for (final department in departments) {
      print(department.name);

      if (department.name == 'Dipartimento di Scienze Matematiche, Informatiche e Fisiche') {
        print('');
        var degreeTypes = UniudTimetableAPI.getDegreeTypes(department);

        for (final degreeType in degreeTypes) {
          print(degreeType.name);

          if (degreeType.name == 'Laurea') {
            print('');
            var degrees = UniudTimetableAPI.getDegrees(degreeType);

            for (final degree in degrees) {
              print(degree.name);

              if (degree.name == 'INFORMATICA') {
                print('');
                var periods = UniudTimetableAPI.getPeriods(degree);

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
    var courseDescriptors =
      await UniudTimetableAPI.getCourseDescriptors(
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
    var course =
      await UniudTimetableAPI.getCourse(
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
