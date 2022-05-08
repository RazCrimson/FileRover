import 'dart:io';

import 'package:file_rover/fs/backends/local/file.dart';
import 'package:file_rover/fs/contracts/entity.dart';
import 'package:path/path.dart' as pth;
import 'directory.dart';

abstract class LocalFsEntity extends FsEntity {
  final FileSystemEntity _entity;
  late final FileStat _stat;

  LocalFsEntity(this._entity) : _stat = _entity.statSync();

  @override
  int get size => _stat.size;

  @override
  String get path => _entity.path;

  @override
  String get basename => _entity.path.split('/').last;

  @override
  String get dirname => _entity.parent.path;

  @override
  DateTime get changedTime => _stat.changed;

  @override
  DateTime get modifiedTime => _stat.modified;

  @override
  LocalFsDirectory get parent => LocalFsDirectory(_entity.parent);

  Future<LocalFsEntity> rename(String name) async {
    final renamedEntity = await _entity.rename(pth.join(dirname, name));
    if (isDirectory()) return LocalFsDirectory(renamedEntity as Directory);
    return LocalFsFile(renamedEntity);
  }

  Future<void> delete({bool recursive = false}) async {
    await _entity.delete(recursive: recursive);
  }
}
