
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../fs/sorters/enums.dart';
import '../providers/sort.dart';

class RenameEntryWidget extends StatefulWidget {
  final FileSystemEntity entity;

  const RenameEntryWidget({Key? key, required this.entity}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RenameEntryWidget();
}

class _RenameEntryWidget extends State<RenameEntryWidget> {

  Future<void> handleRename(BuildContext context, String newName) async {

  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController renameField = TextEditingController();

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: TextField(controller: renameField)),
            TextButton(
              onPressed: () async {
                final entityName = renameField.text;
                HapticFeedback.vibrate();
                try {
                  await widget.entity.rename(widget.entity.parent.path + "/" + entityName);
                } catch (e) {
                  print(e);
                }
                Navigator.pop(context);
                final val = Provider.of<SortProvider>(context, listen: false).sortBy;
                Provider.of<SortProvider>(context, listen: false).sortBy = SortBy.name;
                Provider.of<SortProvider>(context, listen: false).sortBy = SortBy.type;
                Provider.of<SortProvider>(context, listen: false).sortBy = val;
              },
              child: const Text('Rename'),
            )
          ],
        ),
      ),
    );
  }
}
