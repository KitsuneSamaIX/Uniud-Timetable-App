import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uniud_timetable_app/apis/uniud_timetable_api.dart';
import 'package:uniud_timetable_app/utilities/profiles.dart';

// PROFILE CONFIGURATION FLOW

class DepartmentSelectionPage extends StatelessWidget {
  final ProfileBuilder profileBuilder = ProfileBuilder();

  DepartmentSelectionPage({Key? key}) : super(key: key);

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
            return _CustomListView(
              itemCount: deparments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    deparments[index].name,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    profileBuilder.department = deparments[index];
                    _pushNextPage(context, profileBuilder);
                  },
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

  void _pushNextPage(BuildContext context, ProfileBuilder profileBuilder) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => DegreeTypeSelectionPage(profileBuilder: profileBuilder),
      ),
    );
  }
}

class DegreeTypeSelectionPage extends StatelessWidget {
  final ProfileBuilder profileBuilder;

  const DegreeTypeSelectionPage({Key? key, required this.profileBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final degreeTypes = UniudTimetableAPI.getDegreeTypes(profileBuilder.department!);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select your Degree Type'),
      ),
      body: _CustomListView(
        itemCount: degreeTypes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              degreeTypes[index].name,
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              profileBuilder.degreeType = degreeTypes[index];
              _pushNextPage(context, profileBuilder);
            },
          );
        },
      ),
    );
  }

  void _pushNextPage(BuildContext context, ProfileBuilder profileBuilder) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => DegreeSelectionPage(profileBuilder: profileBuilder),
      ),
    );
  }
}

class DegreeSelectionPage extends StatelessWidget {
  final ProfileBuilder profileBuilder;

  const DegreeSelectionPage({Key? key, required this.profileBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final degrees = UniudTimetableAPI.getDegrees(profileBuilder.degreeType!);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select your Degree'),
      ),
      body: _CustomListView(
        itemCount: degrees.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              degrees[index].name,
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              profileBuilder.degree = degrees[index];
              _pushNextPage(context, profileBuilder);
            },
          );
        },
      ),
    );
  }

  void _pushNextPage(BuildContext context, ProfileBuilder profileBuilder) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => PeriodSelectionPage(profileBuilder: profileBuilder),
      ),
    );
  }
}

class PeriodSelectionPage extends StatelessWidget {
  final ProfileBuilder profileBuilder;

  const PeriodSelectionPage({Key? key, required this.profileBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final periods = UniudTimetableAPI.getPeriods(profileBuilder.degree!);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select the Period'),
      ),
      body: _CustomListView(
        itemCount: periods.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              periods[index].name,
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              profileBuilder.period = periods[index];
              _pushNextPage(context, profileBuilder);
            },
          );
        },
      ),
    );
  }

  void _pushNextPage(BuildContext context, ProfileBuilder profileBuilder) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            CourseSelectionPage(profileBuilder: profileBuilder),
      ),
    );
  }
}

class CourseSelectionPage extends StatefulWidget {
  final ProfileBuilder profileBuilder;

  const CourseSelectionPage({Key? key, required this.profileBuilder})
      : super(key: key);

  @override
  State<CourseSelectionPage> createState() => _CourseSelectionPageState();
}

class _CourseSelectionPageState extends State<CourseSelectionPage> {
  final Set<CourseDescriptor> _selectedCourses = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select your Courses'),
        actions: [
          IconButton(
            onPressed: () {
              if (_selectedCourses.isNotEmpty) {
                widget.profileBuilder.courseDescriptors = _selectedCourses;
                _pushNextPage(context, widget.profileBuilder);
              } else {
                showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Please, select at least one course.'),
                    actions: [
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                );
              }
            },
            icon: const Icon(
              Icons.done,
              size: 28,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: UniudTimetableAPI.getCourseDescriptors(
            widget.profileBuilder.degree!, widget.profileBuilder.period!),
        builder: (BuildContext context, AsyncSnapshot<List<CourseDescriptor>> snapshot) {
          if (snapshot.hasData) {
            final courseDescriptors = snapshot.data!;
            return _CustomListView(
              itemCount: courseDescriptors.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  title: Row(
                    children: [
                      IconButton(
                        onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text(courseDescriptors[index].name),
                            // content: const Text('AlertDialog description'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        ),
                        icon: const Icon(Icons.info_outline),
                      ),
                      Expanded(
                        flex: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              courseDescriptors[index].name,
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${courseDescriptors[index].credits} CFU',
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                            Text(
                              courseDescriptors[index].professor != '' ? 'Prof. ${courseDescriptors[index].professor}' : '',
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  value: _selectedCourses.contains(courseDescriptors[index]),
                  onChanged: (value) {
                    setState(() {
                      if (value ?? false) {
                        _selectedCourses.add(courseDescriptors[index]);
                      } else {
                        _selectedCourses.remove(courseDescriptors[index]);
                      }
                    });
                  },
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

  void _pushNextPage(BuildContext context, ProfileBuilder profileBuilder) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            ProfileNamePage(profileBuilder: profileBuilder),
      ),
    );
  }
}

class ProfileNamePage extends StatefulWidget {
  final ProfileBuilder profileBuilder;

  const ProfileNamePage({Key? key, required this.profileBuilder,})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileNamePageState();
}

class _ProfileNamePageState extends State<ProfileNamePage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold( // TODO WillPopScope to avoid the user going back (popping this route) before the loading is completed.
      appBar: AppBar(
        title: const Text('Name your Profile'),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          children: [
            const SizedBox(height: 64,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextFormField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Profile Name',
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r"[0-9a-zA-Z_ ]")),
                ],
                validator: (value) {
                  // TODO check here if there are other profiles with the same name, if there are return null (which means invalid) on this function
                  // TODO remember to remove the trailing whitespaces before checking the name (and also before saving the name)
                  // TODO remember to also enforce a reasonable limit on the length of the profile's name
                  if (value == null || value.isEmpty) {
                    return 'Please set a profile name.';
                  } else if (value.contains('a')) { // TODO remove this test
                    return 'Test validation!';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            const SizedBox(height: 32,),
            _isLoading ? const CircularProgressIndicator() :
            ElevatedButton(
              onPressed: () {
                final text = _textEditingController.text;
                widget.profileBuilder.name = text;
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = true;
                    _loadCourses().then((_) => Navigator.of(context).popUntil((route) => route.isFirst));
                  });
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _loadCourses() async {
    widget.profileBuilder.courses = {};
    for (final courseDescriptor in widget.profileBuilder.courseDescriptors!) {
      widget.profileBuilder.courses!.add(await UniudTimetableAPI.getCourse(courseDescriptor));
    }
    final profilesProvider = Provider.of<Profiles>(context, listen: false);
    profilesProvider.addProfile(widget.profileBuilder.build());
  }
}

// COMMON

class _CustomListView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;

  const _CustomListView({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      child: ListTileTheme(
        data: ListTileThemeData(
          tileColor: Theme.of(context).colorScheme.primaryContainer,
          textColor: Theme.of(context).colorScheme.onPrimaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: itemCount,
          separatorBuilder: (context, index) => const SizedBox(height: 16,),
          itemBuilder: itemBuilder,
        ),
      ),
    );
  }
}

class _ConnectionErrorMessage extends StatelessWidget {
  const _ConnectionErrorMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 16),
              child: Icon(
                Icons.warning_amber_rounded,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const Padding(
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
