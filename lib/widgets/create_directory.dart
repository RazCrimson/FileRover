import 'package:file_rover/providers/storage_path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../fs/utils.dart';

class CreateDirectoryWidget extends StatelessWidget {
  const CreateDirectoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController folderName = TextEditingController();
    final storagePathProvider = Provider.of<StoragePathProvider>(context);

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: TextField(controller: folderName)),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Create Folder
                  await FileSystemUtils.createFolder(storagePathProvider.path, folderName.text);
                  // Open Created Folder
                  storagePathProvider.path += "/" + folderName.text;
                } catch (e) {}

                Navigator.pop(context);
              },
              child: const Text('Create Folder'),
            )
          ],
        ),
      ),
    );
  }
}
