import 'package:file_rover/providers/sort.dart';
import 'package:file_rover/providers/storage_path.dart';
import 'package:file_rover/screens/file_browser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoragePathProvider("/storage/emulated/0")),
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
