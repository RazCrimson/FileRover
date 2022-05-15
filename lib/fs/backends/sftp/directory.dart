import 'package:dartssh2/dartssh2.dart';

import 'package:file_rover/fs/contracts/directory.dart';

import 'entity.dart';

class SftpFsDirectory extends SftpFsEntity with FsDirectory {
  SftpFsDirectory(SftpName sftpName, SftpFsDirectory parent) : super(sftpName, parent);

  SftpFsDirectory.createRoot(SftpName sftpName) : super.createRoot(sftpName) {
    parent = this;
  }
}
