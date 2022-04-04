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
    final profiles = profilesProvider.profiles;
    return Center(
      child: ListView.separated(
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(profiles[index].name),
            subtitle: Text(profiles[index].degreeName),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
    );
  }
}
