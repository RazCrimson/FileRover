import 'dart:io';

import 'package:file_rover/fs/contracts/entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../fs/sorters/enums.dart';
import '../providers/sort_options.dart';

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
                  await widget.entity.rename(entityName);
                } catch (e) {
                  print(e);
                }
                Navigator.pop(context);
                final val = Provider.of<SortOptions>(context, listen: false).sortBy;
                Provider.of<SortOptions>(context, listen: false).sortBy = SortBy.name;
                Provider.of<SortOptions>(context, listen: false).sortBy = SortBy.type;
                Provider.of<SortOptions>(context, listen: false).sortBy = val;
              },
              child: const Text('Rename'),
            )
          ],
        ),
      ),
    );
  }
}
