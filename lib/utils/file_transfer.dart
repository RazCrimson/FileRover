import 'dart:io';

import 'package:file_rover/providers/browser.dart';
import 'package:file_rover/providers/session.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../fs/backends/local/directory.dart';
import '../fs/contracts/file.dart';

Future<void> downloadFile(BuildContext ctx, FsFile file) async {
  final currentController = Provider.of<BrowserProvider>(ctx, listen: false).controller;
  final localController = Provider.of<SessionProvider>(ctx, listen: false).localController;

  final LocalFsDirectory dir = (await localController.getMountsLocations()).first;
  final LocalFsDirectory downloadsDir = LocalFsDirectory(Directory("${dir.path}/Download"));

  final bytes = await currentController.readFile(file);
  await localController.writeFile(downloadsDir, file.basename, bytes);
}
