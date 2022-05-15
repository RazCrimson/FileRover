import 'package:file_rover/dao/credential.dart';
import 'package:file_rover/fs/backends/local/controller.dart';
import 'package:file_rover/providers/browser.dart';
import 'package:file_rover/providers/session.dart';
import 'package:file_rover/screens/file_browser.dart';
import 'package:file_rover/screens/select_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionProvider(CredentialDB(), LocalFsController())),
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
    return MaterialApp(
      initialRoute: '/storages',
      routes: {
        '/storages': (context) => const SelectStorage(),
        '/browser': (context) => const FileBrowser(),
      },
      color: Colors.red,
    );
  }
}
