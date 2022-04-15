import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uniud_timetable_app/utilities/profiles.dart';

class ProfilesPage extends StatefulWidget {
  const ProfilesPage({Key? key}) : super(key: key);

  @override
  State<ProfilesPage> createState() => _ProfilesPageState();
}

class _ProfilesPageState extends State<ProfilesPage> {
  @override
  Widget build(BuildContext context) {
    final profilesProvider = Provider.of<Profiles>(context);

    if (profilesProvider.profiles.isNotEmpty) {
      return ListView.separated(
        itemCount: profilesProvider.profiles.length,
        itemBuilder: (context, index) {
          return ListTile(
            isThreeLine: true,
            title: Text(
              profilesProvider.profiles[index].name,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            subtitle: Text(
              '${profilesProvider.profiles[index].degreeName}\n'
                  '${profilesProvider.profiles[index].degreeTypeName}, '
                  '${profilesProvider.profiles[index].periodName}',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      );
    } else {
      return DefaultTextStyle(
        style: TextStyle(
          fontSize: 18,
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.w600,
        ),
        child: Align(
          alignment: const Alignment(0, -0.6),
          child: SizedBox(
            width: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.people_alt_rounded, size: 60, color: Theme.of(context).colorScheme.secondary,),
                const SizedBox(height: 16,),
                const Text('Fellow student, welcome to the profile creation '
                    'tool!\nYou can create your first profile by tapping on '
                    'the plus icon at the bottom right of the screen.', textAlign: TextAlign.center,),
              ],
            ),
          ),
        ),
      );
    }
  }
}
