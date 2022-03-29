import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uniud_timetable_app/utilities/app_theme_changer.dart';

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
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _separateItems(
          items: [
            const _ThemeSettings(),
            _SettingsGroup(
              title: 'Licenses',
              elements: [
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text('About'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => showAboutDialog(context: context),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text('About'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => showAboutDialog(context: context),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text('About'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => showAboutDialog(context: context),
                ),
              ],
            ),
          ],
          separator: const SizedBox(height: 32,),
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> elements;

  const _SettingsGroup({Key? key, required this.title, required this.elements})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GroupHeading(title: title,),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 0), // TODO
          child: Column(
            children: _separateItems(
              items: elements,
              separator: const Divider()
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsElement extends StatelessWidget {
  const _SettingsElement({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class _GroupHeading extends StatelessWidget {
  final String title;

  const _GroupHeading({Key? key, required this.title}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
        const SizedBox(height: 8,),
      ],
    );
  }
}

class _ThemeSettings extends StatelessWidget {
  const _ThemeSettings({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate the rows with the options
    final separatedAppThemeModeOptions = _separateItems(
      items: List.generate(_appThemeModes.length, (index) =>
          _ThemeModeOption(appThemeMode: _appThemeModes[index])
      ),
      separator: const Spacer(),
    );
    final separatedAppColorSchemeSeeds = _separateItems(
      items: List.generate(_appColorSchemeSeeds.length, (index) =>
          _ColorSchemeSeedOption(appColorSchemeSeed: _appColorSchemeSeeds[index])
      ),
      separator: const Spacer(),
    );
    // Compose and return
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _GroupHeading(title: 'Theme',),
        Column(
          children: [
            Row(children: separatedAppThemeModeOptions,),
            const SizedBox(height: 16,),
            Row(children: separatedAppColorSchemeSeeds,),
          ],
        ),
      ],
    );
  }
}

class _ThemeModeOption extends StatelessWidget {
  final _AppThemeMode appThemeMode;

  const _ThemeModeOption({Key? key, required this.appThemeMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<AppThemeModel>(context);
    final selected = themeProvider.themeMode == appThemeMode.mode ? true : false;
    return Expanded(
      flex: 10,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTap: () => themeProvider.setThemeMode(appThemeMode.mode),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: constraints.maxWidth,
              height: constraints.maxWidth,
              decoration: BoxDecoration(
                color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
              ),
              child: Icon(appThemeMode.icon),
            ),
          );
        },
      ),
    );
  }
}

class _ColorSchemeSeedOption extends StatelessWidget {
  final MaterialColor appColorSchemeSeed;

  const _ColorSchemeSeedOption({Key? key, required this.appColorSchemeSeed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<AppThemeModel>(context);
    final selected = themeProvider.colorSchemeSeed == appColorSchemeSeed ? true : false;
    return Expanded(
      flex: 10,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTap: () => themeProvider.setColorSchemeSeed(appColorSchemeSeed),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: constraints.maxWidth,
              height: constraints.maxWidth,
              decoration: BoxDecoration(
                color: appColorSchemeSeed,
                borderRadius: BorderRadius.circular(16),
              ),
              child: selected ? const Icon(Icons.circle) : null,
            ),
          );
        },
      ),
    );
  }
}

/// Separates a list of Widgets with a separator Widget.
List<Widget> _separateItems({required List<Widget> items, required Widget separator}) {
  final List<Widget> separatedItems = [];
  final lastIndex = items.length - 1;
  items.asMap().forEach((index, item) {
    separatedItems.add(item);
    if (index != lastIndex) {
      separatedItems.add(separator);
    }
  });
  return separatedItems;
}

class _AppThemeMode {
  final ThemeMode mode;
  final String title;
  final IconData icon;

  const _AppThemeMode({
    required this.mode,
    required this.title,
    required this.icon,
  });
}

const List<_AppThemeMode> _appThemeModes = [
  _AppThemeMode(
    mode: ThemeMode.light,
    title: 'Light',
    icon: Icons.brightness_5_rounded,
  ),
  _AppThemeMode(
    mode: ThemeMode.dark,
    title: 'Dark',
    icon: Icons.brightness_2_rounded,
  ),
  _AppThemeMode(
    mode: ThemeMode.system,
    title: 'Auto',
    icon: Icons.brightness_4_rounded,
  ),
];

const List<MaterialColor> _appColorSchemeSeeds = [
  Colors.teal,
  Colors.green,
  Colors.blue,
  Colors.orange,
  Colors.red,
  Colors.purple,
];
