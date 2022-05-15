import 'dart:io';
import 'dart:typed_data';

import 'package:file_rover/fs/contracts/file.dart';

import 'entity.dart';

class LocalFsFile extends LocalFsEntity with FsFile {
  LocalFsFile(FileSystemEntity entity) : super(entity);

  Future<Uint8List> read() {
    return (entity as File).readAsBytes();
  }
}
