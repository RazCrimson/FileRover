import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;

import 'package:file_rover/fs/contracts/directory.dart';

import 'entity.dart';
import 'file.dart';

class LocalFsDirectory extends LocalFsEntity with FsDirectory {
  LocalFsDirectory(Directory entity) : super(entity);

  /// Get a list of entities present in the given directory
  Future<List<LocalFsEntity>> getEntities() async {
    PermissionStatus status = await Permission.manageExternalStorage.request();
    while (!status.isGranted) {
      status = await Permission.manageExternalStorage.request();
    }
    status = await Permission.storage.request();
    while (!status.isGranted) {
      status = await Permission.storage.request();
    }

    final dir = entity as Directory;
    return await dir.list().map((FileSystemEntity entity) {
      if (entity is Directory) return LocalFsDirectory(entity);
      return LocalFsFile(entity);
    }).toList();
  }

  /// Creates a directory if it doesn't exist.
  ///
  /// Returns a future for the created directory
  Future<LocalFsDirectory> createDirectory(String name) async {
    return Directory(p.join(path, name)).create().then((dir) => LocalFsDirectory(dir));
  }
}
