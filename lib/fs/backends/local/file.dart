import 'dart:io';

import 'package:file_rover/fs/contracts/file.dart';

import 'entity.dart';

class LocalFsFile extends LocalFsEntity with FsFile {
  LocalFsFile(FileSystemEntity entity) : super(entity);
}
