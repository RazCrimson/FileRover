import 'package:flutter/material.dart';

import '../fs/contracts/controller.dart';
import '../fs/contracts/directory.dart';

class CurrentDirectory with ChangeNotifier {
  FsDirectory? _currentDirectory;
  FsController? _fsController;

  void updateController(FsController? controller) {
    _fsController = controller;
    _fsController?.getMountsLocations().then((storages) => _currentDirectory = storages[0]);
  }

  FsDirectory? get directory => _currentDirectory;

  set directory(FsDirectory? path) {
    _currentDirectory = path;
    notifyListeners();
  }

  void openDirectory(FsDirectory? dir) {
    directory = dir;
  }

  /// return true if current directory is the root. false, if the current directory not on root of the storage.
  Future<bool> isRootDirectory() async {
    if (_fsController == null) return false;

    final storages = await _fsController?.getMountsLocations() ?? [];
    return storages.where((element) => element.path == _currentDirectory?.path).isNotEmpty;
  }

  /// Jumps to the parent directory of currently opened directory if the parent is accessible.
  Future<void> goToParentDirectory() async {
    if (await isRootDirectory() || _currentDirectory == null) return;
    openDirectory(_currentDirectory?.parent);
  }

  void manualRebuild() {
    notifyListeners();
  }
}
