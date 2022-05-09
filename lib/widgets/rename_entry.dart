import 'package:dartssh2/dartssh2.dart';
import 'package:file_rover/fs/contracts/entity.dart';
import 'package:file_rover/providers/current_directory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../providers/current_controller.dart';

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
    final fsController = Provider.of<CurrentController>(context, listen: false).controller;
    if (fsController == null) return Container();

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
                  await fsController.rename(widget.entity, entityName);
                } on SftpError catch (e, _) {
                  Fluttertoast.showToast(msg: e.message);
                }
                Navigator.pop(context);
                Provider.of<CurrentDirectory>(context, listen: false).manualRebuild();
              },
              child: const Text('Rename'),
            )
          ],
        ),
      ),
    );
  }
}
