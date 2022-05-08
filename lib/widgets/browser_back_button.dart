import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/current_directory.dart';

class BrowserBackButton extends StatefulWidget {
  const BrowserBackButton({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BrowserBackButton();
}

class _BrowserBackButton extends State<BrowserBackButton> {
  DateTime? lastInvocationAtRoot;

  _BrowserBackButton();

  Future<void> handleButtonPress(BuildContext context) async {
    final currentDirProvider = Provider.of<CurrentDirectory>(context, listen: false);

    HapticFeedback.vibrate();
    if (await currentDirProvider.isRootDirectory()) {
      if (lastInvocationAtRoot != null && DateTime.now().difference(lastInvocationAtRoot!).inSeconds < 3) {
        await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', true);
      }
      lastInvocationAtRoot = DateTime.now();
    } else {
      currentDirProvider.goToParentDirectory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => handleButtonPress(context));
  }
}
