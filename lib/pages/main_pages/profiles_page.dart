import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:uniud_timetable_app/models/profile_models.dart';
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
          return _ProfileTile(
            profile: profilesProvider.profiles[index],
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
                const Text(
                  'Welcome to the profile creation tool!\n'
                      'You can create a profile by tapping on the + icon at '
                      'the bottom right of the screen.\n\n'
                      'PRO TIP: a profile can be deleted by sliding it from'
                      ' right to left.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

class _ProfileTile extends StatelessWidget {
  final Profile profile;

  const _ProfileTile({
    Key? key, required this.profile
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(profile),
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () =>
              Provider.of<Profiles>(context, listen: false).removeProfile(profile),
        ),
        children: [
          SlidableAction(
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'Delete',
            onPressed: (context) =>
                Provider.of<Profiles>(context, listen: false).removeProfile(profile),
          ),
        ],
      ),
      child: ListTile(
        isThreeLine: true,
        title: Text(
          profile.name,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        subtitle: Text(
          '${profile.degreeName}\n'
              '${profile.degreeTypeName}, ${profile.periodName}',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }
}
