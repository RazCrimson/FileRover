import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/browser.dart';

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
    final browserProvider = Provider.of<BrowserProvider>(context, listen: false);

    if (await browserProvider.isMountLocation()) {
      if (DateTime.now().difference(lastInvocationAtRoot).inSeconds < 3) return true;
      lastInvocationAtRoot = DateTime.now();
    } else {
      browserProvider.goToParentDirectory();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: widget.child, onWillPop: () => handleButtonPress(context));
  }
}
