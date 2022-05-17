import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:file_rover/dao/credential.dart';
import 'package:file_rover/fs/backends/local/controller.dart';
import 'package:file_rover/providers/browser.dart';
import 'package:file_rover/providers/selection.dart';
import 'package:file_rover/providers/session.dart';
import 'package:file_rover/providers/settings.dart';
import 'package:file_rover/screens/file_browser.dart';
import 'package:file_rover/screens/select_storage.dart';
import 'package:file_rover/screens/settings.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionProvider(CredentialDB(), LocalFsController())),
        ChangeNotifierProvider(create: (_) => SelectionProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => BrowserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return FutureBuilder(
        future: settingsProvider.initialPreferenceLoad,
        builder: (context, snapshot) => MaterialApp(
            initialRoute: '/storages',
            routes: {
              '/storages': (context) => const SelectStorage(),
              '/settings': (context) => const Settings(),
              '/browser': (context) => const FileBrowser(),
            },
            theme: ThemeData(
              // Define the default brightness and colors.
              brightness: settingsProvider.darkMode ? Brightness.dark : Brightness.light,
              primaryColor: settingsProvider.appColor,

              // Define the default `TextTheme`. Use this to specify the default
              // text styling for headlines, titles, bodies of text, and more.
              textTheme: const TextTheme(
                headline1: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
                headline6: TextStyle(fontSize: 20.0),
                bodyText2: TextStyle(fontSize: 14.0),
              ),
            )));
  }
}
