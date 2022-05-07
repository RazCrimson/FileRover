import 'entity.dart';

abstract class FsFile implements FsEntity {
  @override
  bool isDirectory() {
    return false;
  }

  String getExtension() {
    return basename.split('.').last;
  }
}
