import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../sorters/enums.dart';
import '../sorters/factory.dart';
import 'directory.dart';
import 'entity.dart';
import 'file.dart';

abstract class FsController<Entity extends FsEntity, File extends FsFile, Directory extends FsDirectory>
    extends Equatable {
  // Identify each unique controllers
  String getIdentity();

  // return true if the controller manages a local fs
  bool isLocal();

  // Implement props for equality checks
  @override
  List<Object> get props => [getIdentity()];

  // To generate toString methods
  @override
  bool get stringify => true;

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

  Future<Uint8List> readFile(File file);

  Future<void> writeFile(Directory dir, String filename, Uint8List bytes);
}
