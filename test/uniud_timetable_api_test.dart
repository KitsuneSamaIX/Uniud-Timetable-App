import 'package:test/test.dart';
import 'package:uniud_timetable_app/uniud_timetable_api.dart';

void main() {
  test('Test the API with a specific call.', () async {

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
}
