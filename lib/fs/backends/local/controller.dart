import 'dart:io';
import 'dart:typed_data';
import 'package:file_rover/fs/backends/local/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'package:file_rover/fs/contracts/controller.dart';

import 'entity.dart';
import 'directory.dart';
import 'file.dart';

class LocalFsController extends FsController<LocalFsEntity, LocalFsFile, LocalFsDirectory> {
  @override
  String getIdentity() {
    return 'Local Storage';
  }

  @override
  bool isLocal() => true;

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

  @override
  Future<Uint8List> readFile(LocalFsFile file) async {
    // Chaining calls as LocalFs actions don't rely on a connection
    return file.read();
  }

  @override
  Future<void> writeFile(LocalFsDirectory dir, String filename, Uint8List bytes) async {
    final file = await File('${dir.path}/$filename').create(recursive: true);
    await file.writeAsBytes(bytes);
  }

  @override
  Future<void> copy(LocalFsEntity entity, LocalFsDirectory dest) async {
    if (entity is LocalFsFile) {
      await entity.copy('${dest.path}/${entity.basename}');
    } else {
      await compute(copyPathWrapper, {"from": entity.path, "to": '${dest.path}/${entity.basename}'});
    }
  }

  @override
  Future<void> move(LocalFsEntity entity, LocalFsDirectory dest) async {
    if (entity is LocalFsFile) {
      await entity.move(dest);
    } else {
      await compute(copyPathWrapper, {"from": entity.path, "to": '${dest.path}/${entity.basename}'});
      entity.delete(recursive: true);
    }
  }
}
