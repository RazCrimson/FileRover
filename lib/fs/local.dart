import 'dart:io';
import 'dart:math' as math;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'sorters/enums.dart';
import 'sorters/factory.dart';

class LocalFsController {
  /// Return true if FileSystemEntity is File else returns false
  static bool isFile(FileSystemEntity entity) {
    return (entity is File);
  }

  /// Return true if FileSystemEntity is a Directory else returns false
  static bool isDirectory(FileSystemEntity entity) {
    return (entity is Directory);
  }

  /// Get the basename of Directory or File.
  ///
  /// Provide [File], [Directory] or [FileSystemEntity] and returns the name as a [String].
  ///
  /// ie:
  /// ```dart
  /// controller.basename(dir);
  /// ```
  /// to hide the extension of file, showFileExtension = false
  static String basename(FileSystemEntity entity, [bool showExtension = true]) {
    final String entityName = entity.path.split('/').last;
    if (entity is File && !showExtension) {
      return entityName.split('.').first;
    }
    return entityName;
  }

  /// Get the extension of a FileSystemEntity of type File
  static String getFileExtension(File file) {
    return file.path.split("/").last.split('.').last;
  }

  /// Convert byte sizes to human readable format
  static String formatSizeToReadable(int sizeInBytes, [int precision = 2]) {
    if (sizeInBytes == 0) {
      return "0B";
    }
    final double base = math.log(sizeInBytes) / math.log(1024);
    final suffix = const ['B', 'KB', 'MB', 'GB', 'TB'][base.floor()];
    final size = math.pow(1024, base - base.floor());
    return '${size.toStringAsFixed(precision)} $suffix';
  }

  /// Get list of available storage areas in the device
  ///
  /// Returns an empty list if there is no storage
  static Future<List<Directory>> getStorageList() async {
    if (!Platform.isAndroid) {
      return [];
    }

    final storages = (await getExternalStorageDirectories())!;
    return storages.map((Directory e) {
      final List<String> splitPath = e.path.split("/");
      return Directory(splitPath.sublist(0, splitPath.indexWhere((element) => element == "Android")).join("/"));
    }).toList();
  }

  /// Creates a directory if it doesn't exist.
  static Future<void> createFolder(String currentPath, String name) async {
    await Directory(currentPath + "/" + name).create();
  }

  /// Get a list of sorted file system entities based on
  static Future<List<FileSystemEntity>> getSortedEntities(String path, SortBy sortType, SortOrder ordering) async {
    PermissionStatus status = await Permission.manageExternalStorage.request();
    while (!status.isGranted) {
      status = await Permission.manageExternalStorage.request();
    }
    status = await Permission.storage.request();
    while (!status.isGranted) {
      status = await Permission.storage.request();
    }

    final entities = await Directory(path).list().toList();
    return FsEntitySorterFactory.getSorter(sortType).sort(entities, ordering);
  }
}
