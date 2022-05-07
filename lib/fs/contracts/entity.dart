import 'dart:math' as math;

import 'directory.dart';

abstract class FsEntity {
  static const sizeSuffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];

  int get size;

  String get path;

  String get dirname;

  String get basename;

  DateTime get changedTime;

  DateTime get modifiedTime;

  FsDirectory get parent;

  bool isDirectory();

  Future<FsEntity> rename(String name);

  Future<void> delete({bool recursive = false});

  String getReadableSize([int precision = 1]) {
    if (size == 0) return "0B";

    final double base = math.log(size) / math.log(1024);
    final suffix = sizeSuffixes[base.floor()];
    final readableSize = math.pow(1024, base - base.floor());

    return '${readableSize.toStringAsFixed(precision)} $suffix';
  }
}
