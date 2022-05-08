import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:file_rover/fs/contracts/directory.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;
import 'entity.dart';
import 'file.dart';

class SftpFsDirectory extends SftpFsEntity with FsDirectory {
  SftpFsDirectory(SftpName sftpName, SftpFsDirectory? parent) : super(sftpName, parent);
}
