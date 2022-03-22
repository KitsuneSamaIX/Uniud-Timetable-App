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
      ),
      body: Center(
        child: OutlinedButton(
          child: const Text("Enter Selector"),
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
              return ListView.builder(
                itemCount: deparments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(deparments[index].name),
                    // onTap: ,
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'An error has occurred while loading data from UNIUD services.',
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'Loading data from UNIUD services...',
                      ),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
