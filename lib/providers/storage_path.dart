import 'dart:io';

import 'package:flutter/material.dart';

import '../fs/local.dart';

class StoragePathProvider with ChangeNotifier {
  String _path;

  StoragePathProvider(this._path);

  String get path => _path;

  set path(String path) {
    _path = path;
    notifyListeners();
  }

  /// Open directory by providing [Directory].
  void openDirectory(Directory directory) {
    path = directory.path;
  }

  /// return true if current directory is the root. false, if the current directory not on root of the storage.
  Future<bool> isRootDirectory() async {
    final List<Directory> storageList = await LocalFsController.getStorageList();
    return storageList.where((element) => element.path == Directory(path).path).isNotEmpty;
  }

  /// Jumps to the parent directory of currently opened directory if the parent is accessible.
  Future<void> goToParentDirectory() async {
    if (!await isRootDirectory()) {
      openDirectory(Directory(path).parent);
    }
  }

}
