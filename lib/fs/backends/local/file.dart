import 'dart:io';

import '../../contracts/file.dart';
import 'entity.dart';

class LocalFsFile extends LocalFsEntity with FsFile {
  LocalFsFile(FileSystemEntity entity) : super(entity);
}
