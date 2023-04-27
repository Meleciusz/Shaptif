import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'DarkThemeProvider.dart';
import 'SharedPreferences.dart';
import 'main.dart';


class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SettingsViewState();
}

bool status = false;
class SettingsViewState extends State<SettingsView> {

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return SwitchListTile(
      title: const Text('Lights'),
      value: themeChange.darkTheme,
      onChanged: (bool value) {
        setState(() {
          themeChange.darkTheme = value;
          //main();
        });
      },
      secondary: const Icon(Icons.lightbulb_outline),
    );
  }
}
