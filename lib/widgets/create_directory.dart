import 'package:file_rover/providers/current_directory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateDirectoryWidget extends StatefulWidget {
  const CreateDirectoryWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateDirectoryWidget();
}

class _CreateDirectoryWidget extends State<CreateDirectoryWidget> {
  @override
  Widget build(BuildContext context) {
    final currentDirProvider = Provider.of<CurrentDirectory>(context);
    final TextEditingController folderEditorController = TextEditingController();

    if (currentDirProvider.directory == null) {
      return Container();
    }

    return Dialog(
      child: Container(
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
                  await currentDirProvider.directory?.createDirectory(folderName);
                } catch (e) {
                  if (kDebugMode) print(e);
                }
                Navigator.pop(context);
                Provider.of<CurrentDirectory>(context, listen: false).manualRebuild();
              },
              child: const Text('Create Folder'),
            )
          ],
        ),
      ),
    );
  }
}
