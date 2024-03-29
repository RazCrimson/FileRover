import 'package:dartssh2/dartssh2.dart';

import 'package:file_rover/fs/contracts/file.dart';

import 'directory.dart';
import 'entity.dart';

class SftpFsFile extends SftpFsEntity with FsFile {
  SftpFsFile(SftpName sftpName, SftpFsDirectory parent) : super(sftpName, parent);
}
