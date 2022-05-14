import 'package:dartssh2/dartssh2.dart';
import 'package:file_rover/fs/contracts/entity.dart';

import '../../contracts/controller.dart';
import 'entity.dart';
import 'directory.dart';
import 'file.dart';

class SftpFsController extends FsController<SftpFsEntity, SftpFsFile, SftpFsDirectory> {
  final SSHClient _sshClient;
  final SftpClient _sftpClient;

  SftpFsController(this._sshClient, this._sftpClient);

  @override
  String getIdentity() {
    return '${_sshClient.username}@${_sshClient.socket}';
  }

  Future<SftpName> getMatchingSftpName(SftpFsDirectory directory, String name) async {
    final sftpNames = await _sftpClient.listdir(directory.path);
    return sftpNames.where((sftpName) => sftpName.filename == '.').first;
  }

  @override
  Future<SftpFsDirectory> createDirectory(SftpFsDirectory directory, String name) async {
    await _sftpClient.mkdir('${directory.path}/$name');
    final sftpName = await getMatchingSftpName(directory, name);
    if (sftpName.attr.isDirectory) return SftpFsDirectory(sftpName, directory);
    throw UnimplementedError();
  }

  @override
  Future<void> delete(SftpFsEntity entity) async {
    if (entity.isDirectory()) {
      await _sftpClient.rmdir(entity.path);
    } else {
      await _sftpClient.remove(entity.path);
    }
  }

  @override
  Future<SftpFsEntity> rename(SftpFsEntity entity, String name) async {
    await _sftpClient.rename(entity.path, '${entity.dirname}/$name');
    final sftpName = await getMatchingSftpName(entity.parent, name);

    if (sftpName.attr.isDirectory) return SftpFsDirectory(sftpName, entity.parent);
    return SftpFsFile(sftpName, entity.parent);
  }

  @override
  Future<List<FsEntity>> getEntities(SftpFsDirectory directory) async {
    final sftpNames = await _sftpClient.listdir(directory.path);
    return sftpNames.map((sftpName) {
      if (sftpName.attr.isDirectory) return SftpFsDirectory(sftpName, directory);
      return SftpFsFile(sftpName, directory);
    }).toList();
  }

  @override
  Future<List<SftpFsDirectory>> getMountsLocations() async {
    final sftpNames = await _sftpClient.listdir('/');
    SftpName root = sftpNames.where((sftpName) => sftpName.filename == '.').first;
    SftpName wrappedRoot = SftpName(filename: '/', longname: '/', attr: root.attr);
    return [SftpFsDirectory.createRoot(wrappedRoot)];
  }
}
