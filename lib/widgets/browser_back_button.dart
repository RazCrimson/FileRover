import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/storage_path.dart';

class BrowserBackButton extends StatefulWidget {
  const BrowserBackButton({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BrowserBackButton();
}

class _BrowserBackButton extends State<BrowserBackButton> {
  DateTime? lastInvocationAtRoot;

  _BrowserBackButton();

  Future<void> handleButtonPress(BuildContext context) async {
    final storagePathProvider = Provider.of<StoragePathProvider>(context, listen: false);

    HapticFeedback.vibrate();
    if (await storagePathProvider.isRootDirectory()) {
      if (lastInvocationAtRoot != null && DateTime.now().difference(lastInvocationAtRoot!).inSeconds < 3) {
        await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', true);
      }
      lastInvocationAtRoot = DateTime.now();
    } else {
      storagePathProvider.goToParentDirectory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => handleButtonPress(context));
  }
}
