import 'package:flutter/material.dart';

import '../fs/contracts/controller.dart';
import '../fs/contracts/directory.dart';
import '../fs/contracts/entity.dart';
import '../fs/sorters/enums.dart';

class BrowserProvider with ChangeNotifier {
  late FsController controller;
  late FsDirectory _currentDir, _currentMount;
  final List<FsEntity> _selectedEntities = [];

  SortBy _sortBy = SortBy.time;
  SortOrder _sortOrder = SortOrder.descending;

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

  FsDirectory get directory => _currentDir;

  set directory(FsDirectory dir) {
    if (dir.path.startsWith(_currentMount.path)) {
      _currentDir = dir;
      notifyListeners();
    }
  }

  void openDirectory(FsDirectory dir) {
    selectedEntities.clear();
    directory = dir;
  }

  Future<List<FsEntity>> getSortedEntitiesInCurrentDir() async {
    return controller.getSortedEntities(directory, sortBy, sortOrder);
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
    final storages = await controller.getMountsLocations();
    return storages.where((element) => element.path == _currentDir.path).isNotEmpty;
  }

  /// return true if current directory is the root. false, if the current directory not on root of the storage.
  Future<void> openDefaultMountLocation() async {
    final storages = await controller.getMountsLocations();
    mountLocation = storages[0];
  }

  List<FsEntity> get selectedEntities => _selectedEntities;

  void addSelected(FsEntity e) {
    selectedEntities.add(e);
    notifyListeners();
  }

  bool selectedContains(FsEntity e) {
    return selectedEntities.contains(e);
  }

  void removeSelected(FsEntity e) {
    selectedEntities.remove(e);
    notifyListeners();
  }

  void clearSelected() {
    selectedEntities.clear();
    notifyListeners();
  }

  void manualRebuild() {
    notifyListeners();
  }
}
