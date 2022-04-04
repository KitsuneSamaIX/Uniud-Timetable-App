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
    final appSettingsProvider = Provider.of<AppSettings>(context);
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
              title: 'Dark Mode',
              elements: [
                _SettingsElement(
                  title: const Text('True Black'),
                  trailing: Switch(
                    value: appSettingsProvider.darkIsTrueBlack,
                    onChanged: (value) => appSettingsProvider.setDarkIsTrueBlack(value),
                  ),
                ),
              ],
            ),
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
      iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
      textColor: Theme.of(context).colorScheme.onPrimaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
    final separatedAppKeyColors = _separateItems(
      items: List.generate(AppKeyColor.values.length, (index) =>
          _AppKeyColorOption(appKeyColor: AppKeyColor.values[index])
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
            Row(children: separatedAppKeyColors,),
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

class _AppKeyColorOption extends StatelessWidget {
  final AppKeyColor appKeyColor;

  const _AppKeyColorOption({Key? key, required this.appKeyColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appSettingsProvider = Provider.of<AppSettings>(context);
    final selected = appSettingsProvider.appKeyColor == appKeyColor ? true : false;
    return Expanded(
      flex: 10,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTap: () => appSettingsProvider.setAppKeyColor(appKeyColor),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: constraints.maxWidth,
              height: constraints.maxWidth,
              decoration: BoxDecoration(
                color: appKeyColor.toColor(),
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

/// Key Colors to show on theme settings.
enum AppKeyColor {
  teal,
  green,
  blue,
  orange,
  red,
  purple,
}

extension ToColor on AppKeyColor {
  Color toColor() {
    switch (this) {
      case AppKeyColor.teal:
        return Colors.teal;
      case AppKeyColor.green:
        return Colors.green;
      case AppKeyColor.blue:
        return Colors.blue;
      case AppKeyColor.orange:
        return Colors.orange;
      case AppKeyColor.red:
        return Colors.red;
      case AppKeyColor.purple:
        return Colors.purple;
    }
  }
}
