import 'package:flutter/material.dart';

import '../fs/contracts/controller.dart';
import '../fs/contracts/directory.dart';
import '../fs/contracts/entity.dart';
import '../fs/sorters/enums.dart';

class BrowserProvider with ChangeNotifier {
  late FsController _currentController;
  late FsDirectory _currentDir, _currentMount;

  SortBy _sortBy = SortBy.name;
  SortOrder _sortOrder = SortOrder.ascending;

  SortBy get sortBy => _sortBy;

  set sortBy(SortBy sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  SortOrder get sortOrder => _sortOrder;

  set sortOrder(SortOrder sortOrder) {
    _sortOrder = sortOrder;
    notifyListeners();
  }

  void resetSortOptions() {
    _sortBy = SortBy.name;
    _sortOrder = SortOrder.ascending;
    notifyListeners();
  }

  FsController get controller => _currentController;

  set controller(FsController controller) {
    _currentController = controller;
    _currentController.getMountsLocations().then((storages) => mountLocation = storages[0]);
  }

  FsDirectory get directory => _currentDir;

  set directory(FsDirectory dir) {
    if (dir.path.startsWith(_currentMount.path)) {
      _currentDir = dir;
      notifyListeners();
      return;
    }

    print("Invalid Directory at provider");
  }

  void openDirectory(FsDirectory dir) => directory = dir;

  Future<List<FsEntity>> getSortedEntitiesInCurrentDir() async {
    return _currentController.getSortedEntities(directory, sortBy, sortOrder);
  }


  /// Jumps to the parent directory of currently opened directory if the parent is accessible.
  Future<void> goToParentDirectory() async {
    if (await isMountLocation()) return;
    openDirectory(_currentDir.parent);
  }

  FsDirectory get mountLocation => _currentMount;

  set mountLocation(FsDirectory dir) {
    _currentMount = dir;
    openDirectory(dir);
  }

  /// return true if current directory is the root. false, if the current directory not on root of the storage.
  Future<bool> isMountLocation() async {
    final storages = await _currentController.getMountsLocations();
    return storages.where((element) => element.path == _currentDir.path).isNotEmpty;
  }

  void manualRebuild() {
    notifyListeners();
  }
}
