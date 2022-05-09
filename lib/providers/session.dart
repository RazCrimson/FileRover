import 'package:flutter/material.dart';

import '../fs/contracts/controller.dart';

class SessionProvider with ChangeNotifier {
  final List<FsController> _fsControllers;

  SessionProvider(this._fsControllers);

  List<FsController> get controllers => _fsControllers;

  bool addController(FsController controller) {
    if (controllers.contains(controller)) return false;
    controllers.add(controller);
    notifyListeners();
    return true;
  }

  bool removeController(FsController controller) {
    if (!controllers.contains(controller)) return false;
    controllers.remove(controller);
    notifyListeners();
    return true;
  }
}
