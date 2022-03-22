import 'package:flutter/material.dart';
import 'package:uniud_timetable_app/uniud_timetable_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _pushSettingsPage,
            tooltip: 'Settings',
          ),
        ],
      ),
      body: const Center(
        child: Text(
          "Hello Fellow Student!",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _pushSettingsPage() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const SettingsPage(),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Center(
        child: OutlinedButton(
          child: const Text("Create Timetable"),
          onPressed: _pushDepartmentSelectionPage,
        ),
      ),
    );
  }

  void _pushDepartmentSelectionPage() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const DepartmentSelectionPage(),
      ),
    );
  }
}

// ---- COURSES SELECTOR PAGES ----

class DepartmentSelectionPage extends StatefulWidget {
  const DepartmentSelectionPage({Key? key}) : super(key: key);

  @override
  State<DepartmentSelectionPage> createState() => _DepartmentSelectionPageState();
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
          builder:
              (BuildContext context, AsyncSnapshot<DegreesRawIndex> snapshot) {
            if (snapshot.hasData) {
              final deparments =
                  UniudTimetableAPI.getDepartments(snapshot.data!);
              return ListView.separated(
                itemCount: deparments.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      deparments[index].name,
                      textAlign: TextAlign.center,
                    ),
                    onTap: () => _pushDegreeTypeSelectionPage(deparments[index]),
                  );
                },
              );
            } else if (snapshot.hasError) {
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
            } else {
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
          }),
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
  State<DegreeTypeSelectionPage> createState() => _DegreeTypeSelectionPageState();
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
              textAlign: TextAlign.center,
            ),
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
                textAlign: TextAlign.center,
              ),
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

  const PeriodSelectionPage({Key? key, required this.degree})
      : super(key: key);

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
                textAlign: TextAlign.center,
              ),
              // onTap: () => , // TODO
            );
          },
        ),
    );
  }
}



// class GenericSelection<NamedItem> extends StatefulWidget {
//   final DegreeType degreeType;
//
//   const GenericSelection({Key? key, required this.degreeType})
//       : super(key: key);
//
//   @override
//   State<DegreeSelectionPage> createState() => _DegreeSelectionPageState();
// }
//
// class _DegreeSelectionPageState extends State<DegreeSelectionPage> {
//   @override
//   Widget build(BuildContext context) {
//     final degrees = UniudTimetableAPI.getDegrees(widget.degreeType);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Select your Degree'),
//       ),
//       body: ListView.builder(
//         itemCount: degrees.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(
//               degrees[index].name,
//               textAlign: TextAlign.center,
//             ),
//             onTap: () => _pushPeriodSelectionPage(degrees[index]),
//           );
//         },
//       ),
//     );
//   }
//
//   void _pushPeriodSelectionPage(Degree degree) {
//     Navigator.of(context).push(
//       MaterialPageRoute<void>(
//         builder: (context) => PeriodSelectionPage(degree: degree),
//       ),
//     );
//   }
// }
