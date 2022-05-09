import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../contracts/controller.dart';
import 'entity.dart';
import 'directory.dart';
import 'file.dart';

class LocalFsController extends FsController<LocalFsEntity, LocalFsFile, LocalFsDirectory> {
  @override
  String getIdentity() {
    return 'Local Storage';
  }

  @override
  Future<List<LocalFsDirectory>> getMountsLocations() async {
    if (!Platform.isAndroid) {
      return [];
    }
    final storages = await getExternalStorageDirectories() ?? [];

    return storages.map((Directory dir) {
      final List<String> splits = dir.path.split("/");
      final storage = Directory(splits.sublist(0, splits.indexWhere((element) => element == "Android")).join("/"));
      return LocalFsDirectory((storage));
    }).toList();
  }

  @override
  Future<List<LocalFsEntity>> getEntities(LocalFsDirectory directory) {
    // Chaining calls as LocalFs actions don't rely on a connection
    return directory.getEntities();
  }

  @override
  Future<LocalFsDirectory> createDirectory(LocalFsDirectory directory, String name) {
    // Chaining calls as LocalFs actions don't rely on a connection
    return directory.createDirectory(name);
  }

  @override
  Future<LocalFsEntity> rename(LocalFsEntity entity, String name) {
    // Chaining calls as LocalFs actions don't rely on a connection
    return entity.rename(name);
  }

  @override
  Future<void> delete(LocalFsEntity entity) {
    // Chaining calls as LocalFs actions don't rely on a connection
    return entity.delete();
  }
}
