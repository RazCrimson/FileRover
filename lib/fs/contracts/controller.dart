import '../sorters/enums.dart';
import '../sorters/factory.dart';
import 'directory.dart';
import 'entity.dart';
import 'file.dart';

abstract class FsController<Entity extends FsEntity, File extends FsFile, Directory extends FsDirectory> {
  // Delete an entity
  Future<void> delete(Entity entity);

  // Rename an entity
  Future<FsEntity> rename(Entity entity, String name);

  /// Get a list of available storage areas in the device
  ///
  /// Returns an empty list if there is no storage
  Future<List<Directory>> getMountsLocations();
  
  /// Creates a directory if it doesn't exist.
  ///
  /// Returns a future for the created directory
  Future<FsDirectory> createDirectory(Directory directory, String name);
  
  /// Get a list of entities present in the given directory
  Future<List<FsEntity>> getEntities(Directory directory);

  /// Get a sorted list of entities present in the given path
  Future<List<FsEntity>> getSortedEntities(Directory directory, SortBy sortType, SortOrder ordering) async {
    final entities = await getEntities(directory);
    return FsEntitySorterFactory.getSorter(sortType).sort(entities, ordering);
  }
}
