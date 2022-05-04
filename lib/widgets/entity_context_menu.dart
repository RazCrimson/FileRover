import 'dart:io';

import 'package:file_rover/widgets/rename_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../fs/sorters/enums.dart';
import '../fs/utils.dart';
import '../providers/sort.dart';

class EntityContextMenu extends StatefulWidget {
  final FileSystemEntity entity;

  const EntityContextMenu({Key? key, required this.entity}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EntityContextMenu();
}

class _EntityContextMenu extends State<EntityContextMenu> {
  _EntityContextMenu();

  Future<void> handleRename(BuildContext context) async {
    Navigator.pop(context);
    await showDialog(context: context, builder: (context) => RenameEntryWidget(entity: widget.entity));
    final val = Provider.of<SortProvider>(context, listen: false).sortBy;
    Provider.of<SortProvider>(context, listen: false).sortBy = SortBy.name;
    Provider.of<SortProvider>(context, listen: false).sortBy = SortBy.type;
    Provider.of<SortProvider>(context, listen: false).sortBy = val;
  }

  Future<void> handleDelete(BuildContext context) async {
    HapticFeedback.vibrate();
    try {
      await widget.entity.delete(recursive: true);
    } catch (e) {
      print(e);
    }
    Navigator.pop(context);
    final val = Provider.of<SortProvider>(context, listen: false).sortBy;
    Provider.of<SortProvider>(context, listen: false).sortBy = SortBy.name;
    Provider.of<SortProvider>(context, listen: false).sortBy = SortBy.type;
    Provider.of<SortProvider>(context, listen: false).sortBy = val;
  }

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    const spacingBox = SizedBox(height: 10);
    return Dialog(
      child: Container(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<FileStat>(
              future: widget.entity.stat(),
              builder: (context, snapshot) {
                final children = [
                  Text(FileSystemUtils.basename(widget.entity), style: headerStyle),
                  spacingBox,
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Path: ${widget.entity.path}", textAlign: TextAlign.left)),
                  spacingBox
                ];

                if (snapshot.hasData) {
                  children.addAll([
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Type: ${snapshot.data!.type}", textAlign: TextAlign.left)),
                    spacingBox,
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Size: ${snapshot.data!.size}", textAlign: TextAlign.left)),
                    spacingBox,
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Accessed: ${snapshot.data!.accessed}", textAlign: TextAlign.left)),
                    spacingBox,
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Modified: ${snapshot.data!.modified}", textAlign: TextAlign.left)),
                    spacingBox
                  ]);
                }

                children.addAll([
                  TextButton(onPressed: () => handleRename(context), child: const Text('Rename')),
                  spacingBox,
                  TextButton(onPressed: () => handleDelete(context), child: const Text('Delete'))
                ]);

                return Column(mainAxisSize: MainAxisSize.min, children: children);
              })),
    );
  }
}
