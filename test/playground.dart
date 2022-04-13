import 'package:test/test.dart';

void main() {
  test('Playground', () {
    final currentdDateTime = DateTime.now();
    final currentdDateTimeUTC = DateTime.now().toUtc();

    print('Current DateTime (NO UTC):');
    print(currentdDateTime);
    print('currentdDateTime + 100 days = ${currentdDateTime.add(const Duration(days: 100))}');
    print('currentdDateTime + 500 days = ${currentdDateTime.add(const Duration(days: 500))}');
    print('currentdDateTime + 1.000 days = ${currentdDateTime.add(const Duration(days: 1000))}');
    print('currentdDateTime + 10.000 days = ${currentdDateTime.add(const Duration(days: 10000))}');
    print('currentdDateTime + 100.000 days = ${currentdDateTime.add(const Duration(days: 100000))}');

    print('');
    print('');
    print('');

    print('Current DateTime UTC:');
    print(currentdDateTimeUTC);
    print('currentdDateTimeUTC + 100 days = ${currentdDateTimeUTC.add(const Duration(days: 100))}');
    print('currentdDateTimeUTC + 500 days = ${currentdDateTimeUTC.add(const Duration(days: 500))}');
    print('currentdDateTimeUTC + 1.000 days = ${currentdDateTimeUTC.add(const Duration(days: 1000))}');
    print('currentdDateTimeUTC + 10.000 days = ${currentdDateTimeUTC.add(const Duration(days: 10000))}');
    print('currentdDateTimeUTC + 100.000 days = ${currentdDateTimeUTC.add(const Duration(days: 100000))}');
  });
}
