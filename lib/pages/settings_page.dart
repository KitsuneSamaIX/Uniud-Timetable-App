import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uniud_timetable_app/utilities/app_settings.dart';

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
              title: 'Info',
              elements: [
                _SettingsElement(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text('About'),
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
          child: Column(
            children: _separateItems(
              items: elements,
              separator: const Divider(height: 0,)
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsElement extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final void Function()? onTap;

  const _SettingsElement({Key? key, this.leading, this.title, this.trailing, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),),
      minLeadingWidth: 0,
      leading: leading,
      title: title,
      trailing: trailing,
      onTap: onTap,
    );
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
    final separatedFlexSchemes = _separateItems(
      items: List.generate(_availableFlexSchemes.length, (index) =>
          _FlexSchemeOption(flexSchemeWrapper: _availableFlexSchemes[index])
      ),
      separator: const Spacer(),
    );
    // Generate the rows with the options
    final separatedThemeModeOptions = _separateItems(
      items: List.generate(_availableThemeModes.length, (index) =>
          _ThemeModeOption(themeModeWrapper: _availableThemeModes[index])
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
            Row(children: separatedThemeModeOptions,),
            const SizedBox(height: 16,),
            Row(children: separatedFlexSchemes,),
          ],
        ),
      ],
    );
  }
}

class _ThemeModeOption extends StatelessWidget {
  final _ThemeModeWrapper themeModeWrapper;

  const _ThemeModeOption({Key? key, required this.themeModeWrapper})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appSettingsProvider = Provider.of<AppSettings>(context);
    final selected = appSettingsProvider.themeMode == themeModeWrapper.mode ? true : false;
    return Expanded(
      flex: 10,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTap: () => appSettingsProvider.setThemeMode(themeModeWrapper.mode),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: constraints.maxWidth,
              height: constraints.maxWidth,
              decoration: BoxDecoration(
                color: selected ? Theme.of(context).colorScheme.primary : null,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
              ),
              child: Icon(themeModeWrapper.icon),
            ),
          );
        },
      ),
    );
  }
}

class _FlexSchemeOption extends StatelessWidget {
  final _FlexSchemeWrapper flexSchemeWrapper;

  const _FlexSchemeOption({Key? key, required this.flexSchemeWrapper})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appSettingsProvider = Provider.of<AppSettings>(context);
    final selected = appSettingsProvider.flexScheme == flexSchemeWrapper.flexScheme ? true : false;
    return Expanded(
      flex: 10,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTap: () => appSettingsProvider.setFlexScheme(flexSchemeWrapper.flexScheme),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: constraints.maxWidth,
              height: constraints.maxWidth,
              decoration: BoxDecoration(
                color: flexSchemeWrapper.iconColor,
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

class _ThemeModeWrapper {
  final ThemeMode mode;
  final String title;
  final IconData icon;

  const _ThemeModeWrapper({
    required this.mode,
    required this.title,
    required this.icon,
  });
}

/// Ordered list of ThemeMode options to show in settings page.
const List<_ThemeModeWrapper> _availableThemeModes = [
  _ThemeModeWrapper(
    mode: ThemeMode.light,
    title: 'Light',
    icon: Icons.brightness_5_rounded,
  ),
  _ThemeModeWrapper(
    mode: ThemeMode.dark,
    title: 'Dark',
    icon: Icons.brightness_2_rounded,
  ),
  _ThemeModeWrapper(
    mode: ThemeMode.system,
    title: 'Auto',
    icon: Icons.brightness_4_rounded,
  ),
];

class _FlexSchemeWrapper {
  final FlexScheme flexScheme;
  final Color iconColor;

  const _FlexSchemeWrapper({
    required this.flexScheme,
    required this.iconColor
  });
}

/// Ordered list of FlexScheme options to show in settings page.
const List<_FlexSchemeWrapper> _availableFlexSchemes = [
  _FlexSchemeWrapper(
    flexScheme: FlexScheme.aquaBlue,
    iconColor: Colors.teal,
  ),
  _FlexSchemeWrapper(
    flexScheme: FlexScheme.green,
    iconColor: Colors.green,
  ),
  _FlexSchemeWrapper(
    flexScheme: FlexScheme.blue,
    iconColor: Colors.blue,
  ),
  _FlexSchemeWrapper(
    flexScheme: FlexScheme.gold,
    iconColor: Colors.orange,
  ),
  _FlexSchemeWrapper(
    flexScheme: FlexScheme.redWine,
    iconColor: Colors.red,
  ),
  _FlexSchemeWrapper(
    flexScheme: FlexScheme.deepPurple,
    iconColor: Colors.purple,
  ),
];
