import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/current_directory.dart';

class BrowserBackHandler extends StatefulWidget {
  const BrowserBackHandler({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() => _BrowserBackHandler();
}

class _BrowserBackHandler extends State<BrowserBackHandler> {
  DateTime lastInvocationAtRoot = DateTime(2000);

  _BrowserBackHandler();

  Future<bool> handleButtonPress(BuildContext context) async {
    final currentDirProvider = Provider.of<CurrentDirectory>(context, listen: false);

    if (await currentDirProvider.isRootDirectory()) {
      if (DateTime.now().difference(lastInvocationAtRoot).inSeconds < 3) return true;
      lastInvocationAtRoot = DateTime.now();
    } else {
      currentDirProvider.goToParentDirectory();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: widget.child, onWillPop: () => handleButtonPress(context));
  }
}
