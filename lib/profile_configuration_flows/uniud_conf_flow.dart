import 'package:flutter/material.dart';
import 'package:uniud_timetable_app/apis/uniud_timetable_api.dart';

class DepartmentSelectionPage extends StatefulWidget {
  const DepartmentSelectionPage({Key? key}) : super(key: key);

  @override
  State<DepartmentSelectionPage> createState() =>
      _DepartmentSelectionPageState();
}

class _DepartmentSelectionPageState extends State<DepartmentSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select your Department'),
      ),
      body: FutureBuilder(
        future: UniudTimetableAPI.getDegreesRawIndex(),
        builder: (BuildContext context, AsyncSnapshot<DegreesRawIndex> snapshot) {
          if (snapshot.hasData) {
            final deparments = UniudTimetableAPI.getDepartments(snapshot.data!);
            return ListView.separated(
              itemCount: deparments.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    deparments[index].name,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _pushDegreeTypeSelectionPage(deparments[index]),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const _ConnectionErrorMessage();
          } else {
            return const _LoadingScreen();
          }
        },
      ),
    );
  }

  void _pushDegreeTypeSelectionPage(Department department) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => DegreeTypeSelectionPage(department: department),
      ),
    );
  }
}

class DegreeTypeSelectionPage extends StatefulWidget {
  final Department department;

  const DegreeTypeSelectionPage({Key? key, required this.department})
      : super(key: key);

  @override
  State<DegreeTypeSelectionPage> createState() =>
      _DegreeTypeSelectionPageState();
}

class _DegreeTypeSelectionPageState extends State<DegreeTypeSelectionPage> {
  @override
  Widget build(BuildContext context) {
    final degreeTypes = UniudTimetableAPI.getDegreeTypes(widget.department);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select your Degree Type'),
      ),
      body: ListView.separated(
        itemCount: degreeTypes.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              degreeTypes[index].name,
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _pushDegreeSelectionPage(degreeTypes[index]),
          );
        },
      ),
    );
  }

  void _pushDegreeSelectionPage(DegreeType degreeType) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => DegreeSelectionPage(degreeType: degreeType),
      ),
    );
  }
}

class DegreeSelectionPage extends StatefulWidget {
  final DegreeType degreeType;

  const DegreeSelectionPage({Key? key, required this.degreeType})
      : super(key: key);

  @override
  State<DegreeSelectionPage> createState() => _DegreeSelectionPageState();
}

class _DegreeSelectionPageState extends State<DegreeSelectionPage> {
  @override
  Widget build(BuildContext context) {
    final degrees = UniudTimetableAPI.getDegrees(widget.degreeType);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select your Degree'),
      ),
      body: ListView.separated(
        itemCount: degrees.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              degrees[index].name,
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _pushPeriodSelectionPage(degrees[index]),
          );
        },
      ),
    );
  }

  void _pushPeriodSelectionPage(Degree degree) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => PeriodSelectionPage(degree: degree),
      ),
    );
  }
}

class PeriodSelectionPage extends StatefulWidget {
  final Degree degree;

  const PeriodSelectionPage({Key? key, required this.degree}) : super(key: key);

  @override
  State<PeriodSelectionPage> createState() => _PeriodSelectionPageState();
}

class _PeriodSelectionPageState extends State<PeriodSelectionPage> {
  @override
  Widget build(BuildContext context) {
    final periods = UniudTimetableAPI.getPeriods(widget.degree);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select the Period'),
      ),
      body: ListView.separated(
        itemCount: periods.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              periods[index].name,
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _pushCourseSelectionPage(widget.degree, periods[index]),
          );
        },
      ),
    );
  }

  void _pushCourseSelectionPage(Degree degree, Period period) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            CourseSelectionPage(degree: degree, period: period),
      ),
    );
  }
}

class CourseSelectionPage extends StatefulWidget {
  final Degree degree;
  final Period period;

  const CourseSelectionPage(
      {Key? key, required this.degree, required this.period}) : super(key: key);

  @override
  State<CourseSelectionPage> createState() => _CourseSelectionPageState();
}

class _CourseSelectionPageState extends State<CourseSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select your Courses'),
      ),
      body: FutureBuilder(
        future: UniudTimetableAPI.getCourseDescriptors(widget.degree, widget.period),
        builder: (BuildContext context, AsyncSnapshot<List<CourseDescriptor>> snapshot) {
          if (snapshot.hasData) {
            final courses = snapshot.data!;
            return ListView.separated(
              itemCount: courses.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    courses[index].name,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  // onTap: () => , // TODO
                );
              },
            );
          } else if (snapshot.hasError) {
            return const _ConnectionErrorMessage();
          } else {
            return const _LoadingScreen();
          }
        },
      ),
    );
  }
}

// COMMON

class _ConnectionErrorMessage extends StatelessWidget {
  const _ConnectionErrorMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: const <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 32, bottom: 16),
              child: Icon(
                Icons.warning_amber_rounded,
                size: 64,
                color: Colors.orange,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 32, right: 32),
              child: Text(
                'An error has occurred while loading data from UNIUD '
                    'services, please try again later.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        )
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          SizedBox(
            height: 32,
          ),
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              'Loading data from UNIUD services...',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
