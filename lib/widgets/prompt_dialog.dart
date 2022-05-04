
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../fs/sorters/enums.dart';
import '../fs/local.dart';
import '../providers/sort.dart';

class PromptDialogWidget extends StatefulWidget {
  final String path;

  const PromptDialogWidget({Key? key, required this.path}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateDirectoryWidget();
}

class _CreateDirectoryWidget extends State<PromptDialogWidget> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController folderEditorController = TextEditingController();

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: TextField(controller: folderEditorController)),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [TextButton(
              onPressed: () async {
                final folderName = folderEditorController.text;
                try {
                  // Create Folder
                  await LocalFsController.createFolder(widget.path, folderName);
                } catch (e) {
                  print(e);
                }
                Navigator.pop(context);
                final val = Provider.of<SortProvider>(context, listen: false).sortBy;
                Provider.of<SortProvider>(context, listen: false).sortBy = SortBy.name;
                Provider.of<SortProvider>(context, listen: false).sortBy = SortBy.type;
                Provider.of<SortProvider>(context, listen: false).sortBy = val;
              },
              child: const Text('Create Folder'),
            )
          ],
        ),
      ])
    ));
  }
}
