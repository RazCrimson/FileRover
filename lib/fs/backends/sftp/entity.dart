import 'package:dartssh2/dartssh2.dart';
import 'package:file_rover/fs/contracts/entity.dart';
import 'package:meta/meta.dart';

import 'directory.dart';

abstract class SftpFsEntity extends FsEntity {
  final SftpName _sftpName;
  late final SftpFsDirectory _parent;

  SftpFsEntity(this._sftpName, this._parent);

  SftpFsEntity.createRoot(this._sftpName);

  SftpFileAttrs get _attrs => _sftpName.attr;

  @override
  int get size => _attrs.size ?? 0;

  @override
  String get path => '${_parent == this ? "" : "${_parent.path}/"}$basename';

  @override
  String get basename => _sftpName.filename;

  @override
  String get dirname => _parent.path;

  @override
  DateTime get accessedTime => DateTime.fromMillisecondsSinceEpoch((_attrs.accessTime ?? 0) * 1000, isUtc: true);

  @override
  DateTime get modifiedTime => DateTime.fromMillisecondsSinceEpoch((_attrs.modifyTime ?? 0) * 1000, isUtc: true);

  @override
  SftpFsDirectory get parent => _parent;

  @protected
  set parent(SftpFsDirectory dir) => _parent = dir;
}
