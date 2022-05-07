import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../contracts/controller.dart';
import 'directory.dart';
import 'entity.dart';

class LocalFsController extends FsController<LocalFsEntity, LocalFsDirectory> {
  /// Get a list of available storage areas in the device
  ///
  /// Returns an empty list if there is no storage
  @override
  Future<List<LocalFsDirectory>> getStorageList() async {
    if (!Platform.isAndroid) {
      return [];
    }

    final storages = (await getExternalStorageDirectories())!;
    return storages.map((Directory dir) {
      final List<String> splits = dir.path.split("/");
      final storage = Directory(splits.sublist(0, splits.indexWhere((element) => element == "Android")).join("/"));
      return LocalFsDirectory((storage));
    }).toList();
  }
}
