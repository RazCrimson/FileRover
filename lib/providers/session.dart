import 'package:flutter/material.dart';

import '../fs/backends/local/controller.dart';
import '../fs/contracts/controller.dart';

class SessionProvider with ChangeNotifier {
  final LocalFsController _localFsController;
  final List<FsController> _fsControllers = [];

  SessionProvider(this._localFsController);

  LocalFsController get localController => _localFsController;

  List<FsController> get controllers => List<FsController>.from(_fsControllers)..insert(0, _localFsController);

  bool addController(FsController controller) {
    if (controllers.contains(controller)) return false;
    _fsControllers.add(controller);
    notifyListeners();
    return true;
  }

  bool removeController(FsController controller) {
    if (!controllers.contains(controller)) return false;
    _fsControllers.remove(controller);
    notifyListeners();
    return true;
  }
}
