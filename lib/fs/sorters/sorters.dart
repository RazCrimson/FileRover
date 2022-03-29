import 'dart:io';

import 'enums.dart';

abstract class FsEntitySorter {
  Future<List<FileSystemEntity>> sort(List<FileSystemEntity> entities, SortOrder ordering);

  static int _getOrderMultiplier(SortOrder ordering){
    if (ordering == SortOrder.ascending) {
      return 1;
    }
    return -1;
  }

  static Future<Map<FileSystemEntity, FileStat>> _getFsEntityStatMap(List<FileSystemEntity> entities) async {
    final Map<FileSystemEntity, FileStat> fileStatMap = {};
    for (FileSystemEntity e in entities) {
      fileStatMap[e] = (await e.stat());
    }
    return fileStatMap;
  }
}

class FsEntityNameSorter extends FsEntitySorter {
  @override
  Future<List<FileSystemEntity>> sort(List<FileSystemEntity> entities, SortOrder ordering) async {
    final order = FsEntitySorter._getOrderMultiplier(ordering);

    // Make a list of directories and sort by name
    final dirs = entities.whereType<Directory>().toList();
    dirs.sort((a, b) => order * a.path.toLowerCase().compareTo(b.path.toLowerCase()));

    // Make a list of files and sort by name
    final files = entities.whereType<File>().toList();
    files.sort((a, b) => order * a.path.toLowerCase().compareTo(b.path.toLowerCase()));

    return [...dirs, ...files];
  }
}

class FsEntitySizeSorter extends FsEntitySorter {
  @override
  Future<List<FileSystemEntity>> sort(List<FileSystemEntity> entities, SortOrder ordering) async {
    final order = FsEntitySorter._getOrderMultiplier(ordering);

    // Make a list of directories and sort them
    final dirs = entities.whereType<Directory>().toList();
    dirs.sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));

    // Make a list of files and sort them
    final fsEntityStatMap = await FsEntitySorter._getFsEntityStatMap(entities.whereType<File>().toList());

    final statMapList = fsEntityStatMap.entries.toList();
    statMapList.sort((a, b) => order * a.value.size.compareTo(b.value.size));
    final files = statMapList.map((e) => e.key).toList();

    return [...dirs, ...files];
  }
}

class FsEntityTimeSorter extends FsEntitySorter {
  @override
  Future<List<FileSystemEntity>> sort(List<FileSystemEntity> entities, SortOrder ordering) async {
    final order = FsEntitySorter._getOrderMultiplier(ordering);
    final fsEntityStatMap = await FsEntitySorter._getFsEntityStatMap(entities);

    // Create a sorted list of entities by timestamp.
    final statMapList = fsEntityStatMap.entries.toList();
    statMapList.sort((b, a) => order * a.value.modified.compareTo(b.value.modified));

    return statMapList.map((e) => e.key).toList();
  }
}

class FsEntityTypeSorter extends FsEntitySorter {
  @override
  Future<List<FileSystemEntity>> sort(List<FileSystemEntity> entities, SortOrder ordering) async {
    final order = FsEntitySorter._getOrderMultiplier(ordering);

    // Make a list of directories and sort by name
    final dirs = entities.whereType<Directory>().toList();
    dirs.sort((a, b) => order * a.path.toLowerCase().compareTo(b.path.toLowerCase()));

    // Make a list of files and sort by extension
    final files = entities.whereType<File>().toList();
    files.sort((a, b) => order * a.path.toLowerCase().split('.').last.compareTo(b.path.toLowerCase().split('.').last));

    return [...dirs, ...files];
  }
}
