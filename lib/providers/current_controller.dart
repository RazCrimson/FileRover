import 'package:flutter/material.dart';

import '../fs/contracts/controller.dart';

class CurrentController with ChangeNotifier {
  FsController? _fsController;

  CurrentController(this._fsController);

  FsController? get controller => _fsController;

  set controller(FsController? controller) {
    _fsController = controller;
    notifyListeners();
  }
}
