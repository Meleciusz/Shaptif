import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    final showEmbedded = Provider.of<ShowEmbeddedProvider>(context);

    return Column(
      children: [
        SwitchListTile(
          title: const Text('Lights'),
          value: themeChange.darkTheme,
          onChanged: (bool value) {
            setState(() {
              themeChange.darkTheme = value;
            });
          },
          secondary: const Icon(Icons.lightbulb_outline),
        ),
        SwitchListTile(
          title: const Text('Show embedded exercises and trainings'),
          value: showEmbedded.showEmbedded,
          onChanged: (bool value) {
            setState(() {
              showEmbedded.showEmbedded = value;
            });
          },
          secondary: const Icon(FontAwesomeIcons.microchip),
        ),
      ],
    );
  }
}
