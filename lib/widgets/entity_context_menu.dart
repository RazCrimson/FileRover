import 'package:file_rover/fs/contracts/entity.dart';
import 'package:file_rover/widgets/rename_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/current_controller.dart';
import '../providers/current_directory.dart';

class EntityContextMenu extends StatefulWidget {
  final FsEntity entity;

  const EntityContextMenu({Key? key, required this.entity}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EntityContextMenu();
}

class _EntityContextMenu extends State<EntityContextMenu> {
  _EntityContextMenu();

  Future<void> handleRename(BuildContext context) async {
    await showDialog(context: context, builder: (context) => RenameEntryWidget(entity: widget.entity));
    Navigator.pop(context);
    Provider.of<CurrentDirectory>(context, listen: false).manualRebuild();
  }

  Future<void> handleDelete(BuildContext context) async {
    final fsController = Provider.of<CurrentController>(context, listen: false).controller;
    HapticFeedback.vibrate();
    try {
      await fsController?.delete(widget.entity);
    } catch (e) {
      print(e);
    }
    Navigator.pop(context);
    Provider.of<CurrentDirectory>(context, listen: false).manualRebuild();
  }

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    const spacingBox = SizedBox(height: 10);
    final entity = widget.entity;

    return Dialog(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(entity.basename, style: headerStyle),
              spacingBox,
              Align(alignment: Alignment.centerLeft, child: Text("Path: ${entity.path}", textAlign: TextAlign.left)),
              spacingBox,
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Type: ${entity.isDirectory() ? 'Directory' : 'File'}", textAlign: TextAlign.left)),
              spacingBox,
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Size: ${entity.getReadableSize()}", textAlign: TextAlign.left)),
              spacingBox,
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Accessed: ${entity.accessedTime}", textAlign: TextAlign.left)),
              spacingBox,
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Modified: ${entity.modifiedTime}", textAlign: TextAlign.left)),
              spacingBox,
              TextButton(onPressed: () => handleRename(context), child: const Text('Rename')),
              spacingBox,
              TextButton(onPressed: () => handleDelete(context), child: const Text('Delete'))
            ])));
  }
}
