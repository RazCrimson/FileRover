import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../providers/settings.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const NeverScrollableScrollPhysics(),
            children: [
              SwitchListTile.adaptive(
                contentPadding: const EdgeInsets.all(0),
                secondary: settingsProvider.darkMode
                    ? const Icon(CupertinoIcons.sun_max_fill)
                    : const Icon(CupertinoIcons.moon_fill),
                title: settingsProvider.darkMode ? const Text("Light Mode") : const Text("Dark Mode"),
                value: settingsProvider.darkMode,
                onChanged: (value) async {
                  settingsProvider.darkMode = value;
                  await settingsProvider.writePreferences();
                },
                activeColor: Theme.of(context).colorScheme.secondary,
              ),
              SwitchListTile.adaptive(
                contentPadding: const EdgeInsets.all(0),
                secondary: settingsProvider.showHiddenFiles
                    ? const Icon(CupertinoIcons.eye_fill)
                    : const Icon(CupertinoIcons.eye_slash_fill),
                title: settingsProvider.showHiddenFiles
                    ? const Text("Don't show hidden files")
                    : const Text("Show hidden files"),
                value: settingsProvider.showHiddenFiles,
                onChanged: (value) async {
                  settingsProvider.showHiddenFiles = value;
                  await settingsProvider.writePreferences();
                },
                activeColor: Theme.of(context).colorScheme.secondary,
              ),
            ]));
  }
}
