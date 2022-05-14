import 'package:file_rover/fs/contracts/entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/browser.dart';

class RenameEntryWidget extends StatefulWidget {
  final FsEntity entity;

  const RenameEntryWidget({Key? key, required this.entity}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RenameEntryWidget();
}

class _RenameEntryWidget extends State<RenameEntryWidget> {
  Future<void> handleRename(BuildContext context, String newName) async {}

  @override
  Widget build(BuildContext context) {
    final browserProvider = Provider.of<BrowserProvider>(context, listen: false);

    final TextEditingController renameField = TextEditingController(text: widget.entity.basename);

    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: TextFormField(controller: renameField)),
            ElevatedButton(
              onPressed: () async {
                final entityName = renameField.text;
                HapticFeedback.vibrate();
                try {
                  await browserProvider.controller.rename(widget.entity, entityName);
                } catch (e) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
                }
                Navigator.pop(context);
                browserProvider.manualRebuild();
              },
              child: const Text('Rename'),
            )
          ],
        ),
      ),
    );
  }
}
