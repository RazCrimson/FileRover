import 'entity.dart';

abstract class FsDirectory implements FsEntity {
  @override
  bool isDirectory() {
    return true;
  }
}
