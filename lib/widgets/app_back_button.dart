import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/storage_path.dart';

class AppBackButton extends StatefulWidget {
  const AppBackButton({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() => _AppBackButton();
}

class _AppBackButton extends State<AppBackButton> {
  DateTime? lastInvocationAtRoot;

  _AppBackButton();

  Future<bool> handleButtonPress(BuildContext context) async {
    final storagePathProvider = Provider.of<StoragePathProvider>(context, listen: false);

    if (await storagePathProvider.isRootDirectory()) {
      if (lastInvocationAtRoot != null && DateTime.now().difference(lastInvocationAtRoot!).inSeconds < 3) {
        return true;
      }
      lastInvocationAtRoot = DateTime.now();
    } else {
      storagePathProvider.goToParentDirectory();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: widget.child, onWillPop: () => handleButtonPress(context));
  }
}
