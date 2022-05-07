import '../sorters/enums.dart';
import '../sorters/factory.dart';
import 'entity.dart';

abstract class FsDirectory implements FsEntity {
  @override
  bool isDirectory() {
    return true;
  }

  /// Get a list of entities present in the given directory
  Future<List<FsEntity>> getEntities();

  /// Creates a directory if it doesn't exist.
  ///
  /// Returns a future for the created directory
  Future<FsDirectory> createDirectory(String name);

  /// Get a sorted list of entities present in the given path
  Future<List<FsEntity>> getSortedEntities(SortBy sortType, SortOrder ordering) async {
    final entities = await getEntities();
    return FsEntitySorterFactory.getSorter(sortType).sort(entities, ordering);
  }
}
