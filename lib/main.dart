import 'package:file_rover/fs/backends/local/controller.dart';
import 'package:file_rover/providers/current_controller.dart';
import 'package:file_rover/providers/sort.dart';
import 'package:file_rover/providers/current_directory.dart';
import 'package:file_rover/screens/file_browser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final fsController = LocalFsController();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrentController(fsController)),
        ChangeNotifierProxyProvider<CurrentController, CurrentDirectory>(
          create: (_) => CurrentDirectory(),
          update: (_, controller, currentDirNotifier) {
            currentDirNotifier ??= CurrentDirectory();
            return currentDirNotifier..updateController(controller.controller);
          },
        ),
        ChangeNotifierProvider(create: (_) => SortProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const FileBrowser(),
      },
      color: Colors.red,
    );
  }
}
