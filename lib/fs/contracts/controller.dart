import 'directory.dart';
import 'entity.dart';

abstract class FsController<T extends FsEntity, U extends FsDirectory> {
  /// Get a list of available storage areas in the device
  ///
  /// Returns an empty list if there is no storage
  Future<List<U>> getStorageList();
}
