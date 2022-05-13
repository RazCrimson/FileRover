import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/browser.dart';

class CreateDirectoryWidget extends StatefulWidget {
  const CreateDirectoryWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateDirectoryWidget();
}

class _CreateDirectoryWidget extends State<CreateDirectoryWidget> {
  @override
  Widget build(BuildContext context) {
    final browserProvider = Provider.of<BrowserProvider>(context, listen: false);
    final TextEditingController folderEditorController = TextEditingController();

    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: TextField(controller: folderEditorController)),
            TextButton(
              onPressed: () async {
                final folderName = folderEditorController.text;
                // Create Folder
                try {
                  await browserProvider.controller.createDirectory(browserProvider.directory, folderName);
                } catch (e) {
                  if (kDebugMode) print(e);
                }
                Navigator.pop(context);
                browserProvider.manualRebuild();
              },
              child: const Text('Create Folder'),
            )
          ],
        ),
      ),
    );
  }
}
