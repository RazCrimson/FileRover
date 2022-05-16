import 'dart:io';
import 'dart:typed_data';

import 'package:file_rover/fs/contracts/file.dart';

import 'directory.dart';
import 'entity.dart';

class LocalFsFile extends LocalFsEntity with FsFile {
  LocalFsFile(FileSystemEntity entity) : super(entity);

  Future<Uint8List> read() {
    return (entity as File).readAsBytes();
  }

  Future<void> copy(String newPath) async {
    final file = entity as File;
    await file.copy(newPath);
  }

  Future<void> move(LocalFsDirectory dest) async {
    final file = entity as File;
    final newPath = '${dest.path}/$basename';

    try {
      await file.rename(newPath);
    } on FileSystemException catch (_) {
      // if rename fails, copy the source file and then delete it
      copy(newPath);
      await file.delete();
    }
  }
}
