import 'package:file_rover/fs/contracts/controller.dart';
import 'package:file_rover/fs/contracts/directory.dart';
import 'package:file_rover/fs/contracts/entity.dart';
import 'package:flutter/material.dart';

class SelectionProvider with ChangeNotifier {
  bool _isCut = false;
  FsController? _selectedController;
  FsDirectory? _selectedDirectory;
  List<FsEntity>? _selectedEntities;

  bool get isCut => _isCut;

  FsController? get selectedController => _selectedController;

  FsDirectory? get selectedDirectory => _selectedDirectory;

  List<FsEntity>? get selectedEntities => _selectedEntities;

  void select(FsController controller, FsDirectory dir, List<FsEntity> entities, {bool isCut = false}) {
    _isCut = isCut;
    _selectedDirectory = dir;
    _selectedEntities = entities;
    _selectedController = controller;
    notifyListeners();
  }

  void clear() {
    _selectedEntities = null;
    _selectedController = null;
    notifyListeners();
  }
}
