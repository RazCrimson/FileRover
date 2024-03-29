import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';

import 'package:file_rover/fs/contracts/controller.dart';
import 'package:file_rover/fs/contracts/entity.dart';

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

  @override
  bool isLocal() => false;

  Future<SftpName> getMatchingSftpName(SftpFsDirectory directory, String name) async {
    final sftpNames = await _sftpClient.listdir(directory.path);
    return sftpNames.where((sftpName) => sftpName.filename == name).first;
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

  @override
  Future<Uint8List> readFile(SftpFsFile file) async {
    final sftpFile = await _sftpClient.open(file.path);
    return sftpFile.readBytes();
  }

  @override
  Future<void> writeFile(SftpFsDirectory dir, String filename, Uint8List bytes) async {
    final sftpFile = await _sftpClient.open('${dir.path}/$filename',
        mode: SftpFileOpenMode.write | SftpFileOpenMode.create | SftpFileOpenMode.truncate);
    await sftpFile.writeBytes(bytes);
  }

  @override
  Future<void> copy(SftpFsEntity entity, SftpFsDirectory dest) async {
    final session = await _sshClient.execute('cp -r "${entity.path}" "${dest.path}"');
    session.close();
    await session.done;
  }

  @override
  Future<void> move(SftpFsEntity entity, SftpFsDirectory dest) async {
    final session = await _sshClient.execute('mv "${entity.path}" "${dest.path}"');
    session.close();
    await session.done;
  }
}
