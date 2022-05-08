import '../contracts/directory.dart';
import '../contracts/entity.dart';
import '../contracts/file.dart';
import 'enums.dart';

abstract class FsEntitySorter<T extends FsEntity> {
  static int _getOrderMultiplier(SortOrder ordering) {
    return ordering == SortOrder.ascending ? 1 : -1;
  }

  Future<List<FsEntity>> sort(List<FsEntity> entities, SortOrder ordering);
}

class FsEntityNameSorter extends FsEntitySorter {
  @override
  Future<List<FsEntity>> sort(List<FsEntity> entities, SortOrder ordering) async {
    final order = FsEntitySorter._getOrderMultiplier(ordering);

    // Make a list of directories and sort by name
    final dirs = entities.whereType<FsDirectory>().toList();
    dirs.sort((a, b) => order * a.basename.compareTo(b.basename));

    // Make a list of files and sort them by name
    final files = entities.whereType<FsFile>().toList();
    files.sort((a, b) => order * a.basename.compareTo(b.basename));

    return [...dirs, ...files];
  }
}

class FsEntitySizeSorter extends FsEntitySorter {
  @override
  Future<List<FsEntity>> sort(List<FsEntity> entities, SortOrder ordering) async {
    final order = FsEntitySorter._getOrderMultiplier(ordering);

    // Make a list of directories and sort by name
    final dirs = entities.whereType<FsDirectory>().toList();
    dirs.sort((a, b) => order * a.basename.compareTo(b.basename));

    // Make a list of files and sort them by size
    final files = entities.whereType<FsFile>().toList();
    files.sort((a, b) => order * a.size.compareTo(b.size));

    return [...dirs, ...files];
  }
}

class FsEntityTimeSorter extends FsEntitySorter {
  @override
  Future<List<FsEntity>> sort(List<FsEntity> entities, SortOrder ordering) async {
    final order = FsEntitySorter._getOrderMultiplier(ordering);

    // Create a sorted list of entities by timestamp.
    entities.sort((a, b) => order * a.changedTime.compareTo(b.changedTime));
    return entities;
  }
}

class FsEntityTypeSorter extends FsEntitySorter {
  @override
  Future<List<FsEntity>> sort(List<FsEntity> entities, SortOrder ordering) async {
    final order = FsEntitySorter._getOrderMultiplier(ordering);

    // Make a list of directories and sort by name
    final dirs = entities.whereType<FsDirectory>().toList();
    dirs.sort((a, b) => order * a.basename.compareTo(b.basename));

    // Make a list of files and sort by extension
    final files = entities.whereType<FsFile>().toList();
    files.sort((a, b) {
      int cmp = a.getExtension().compareTo(b.getExtension());
      if (cmp != 0) return cmp;
      return a.basename.compareTo(b.basename);
    });

    return [...dirs, ...files];
  }
}
