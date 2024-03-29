import 'dart:math' as math;

import 'package:equatable/equatable.dart';

import 'directory.dart';

abstract class FsEntity extends Equatable {
  static const sizeSuffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];

  // Implement props for equality checks
  @override
  List<Object> get props => [path];

  int get size;

  String get path;

  String get dirname;

  String get basename;

  DateTime get accessedTime;

  DateTime get modifiedTime;

  FsDirectory get parent;

  bool isDirectory();

  String getReadableSize([int precision = 1]) {
    if (size == 0) return "0B";

    final double base = math.log(size) / math.log(1024);
    final suffix = sizeSuffixes[base.floor()];
    final readableSize = math.pow(1024, base - base.floor());

    return '${readableSize.toStringAsFixed(precision)} $suffix';
  }
}
