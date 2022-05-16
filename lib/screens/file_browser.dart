import 'package:file_icon/file_icon.dart';
import 'package:file_rover/fs/contracts/directory.dart';
import 'package:file_rover/fs/contracts/entity.dart';
import 'package:file_rover/fs/contracts/file.dart';
import 'package:file_rover/widgets/browser_back_handler.dart';
import 'package:file_rover/widgets/rename_entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

import '../providers/browser.dart';
import '../utils/file_transfer.dart';
import '../widgets/create_directory.dart';
import '../widgets/entity_context_menu.dart';
import '../widgets/file_list.dart';
import '../widgets/path_bar.dart';
import '../widgets/select_storage.dart';
import '../widgets/sort_dialog.dart';

class FileBrowser extends StatelessWidget {
  const FileBrowser({Key? key}) : super(key: key);

  String getTimeValue(DateTime dateTime) {
    if (DateTime.now().difference(dateTime) < const Duration(days: 2)) return timeago.format(dateTime);
    final dateFormat = DateFormat('dd-MM-yyyy');
    return dateFormat.format(dateTime);
  }

  String getSubTitle(FsEntity entity) {
    String subTitle = "";
    if (!entity.isDirectory()) subTitle += 'Size: ${entity.getReadableSize()}  ';

    subTitle += 'Modified: ${getTimeValue(entity.modifiedTime)}';
    return subTitle;
  }

  @override
  Widget build(BuildContext context) {
    final browserProvider = Provider.of<BrowserProvider>(context);
    final selectedEntities = browserProvider.selectedEntities;

    return BrowserBackHandler(
        child: Scaffold(
            appBar: AppBar(
              leading: selectedEntities.isNotEmpty
                  ? IconButton(onPressed: () => browserProvider.clearSelected(), icon: const Icon(Icons.clear))
                  : null,
              actions: [
                IconButton(
                    onPressed: () => showDialog(context: context, builder: (context) => const SortWidget()),
                    icon: const Icon(Icons.sort_rounded)),
                PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (BuildContext context) {
                      final List<PopupMenuEntry> menuOptions = [
                        PopupMenuItem(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ListTile(
                                minLeadingWidth: 24,
                                horizontalTitleGap: 8,
                                minVerticalPadding: 0,
                                dense: true,
                                title: const Text("New Folder"),
                                onTap: () {
                                  Navigator.pop(context);
                                  showDialog(context: context, builder: (context) => const CreateDirectoryWidget());
                                },
                                leading: const Icon(Icons.create_new_folder_outlined))),
                        PopupMenuItem(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ListTile(
                                minLeadingWidth: 24,
                                horizontalTitleGap: 8,
                                minVerticalPadding: 0,
                                dense: true,
                                title: const Text("Select Mount"),
                                onTap: () {
                                  Navigator.pop(context);
                                  showDialog(context: context, builder: (context) => const SelectStorageWidget());
                                },
                                leading: const Icon(Icons.sd_storage_sharp))),
                      ];

                      if (selectedEntities.isNotEmpty) {
                        if (selectedEntities.length == 1) {
                          final entity = selectedEntities[0];
                          menuOptions.add(PopupMenuItem(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: ListTile(
                                  minLeadingWidth: 24,
                                  horizontalTitleGap: 8,
                                  minVerticalPadding: 0,
                                  dense: true,
                                  title: const Text("Rename"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    showDialog(
                                        context: context, builder: (context) => RenameEntryWidget(entity: entity));
                                    selectedEntities.clear();
                                  },
                                  leading: const Icon(CupertinoIcons.pen))));

                          menuOptions.add(PopupMenuItem(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: ListTile(
                                  minLeadingWidth: 24,
                                  horizontalTitleGap: 8,
                                  minVerticalPadding: 0,
                                  dense: true,
                                  title: const Text("Details"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    showDialog(
                                        context: context, builder: (context) => EntityContextMenu(entity: entity));
                                  },
                                  leading: const Icon(Icons.notes))));

                          if (!(browserProvider.controller.isLocal() || entity.isDirectory())) {
                            menuOptions.add(PopupMenuItem(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: ListTile(
                                    minLeadingWidth: 24,
                                    horizontalTitleGap: 8,
                                    minVerticalPadding: 0,
                                    dense: true,
                                    title: const Text("Download"),
                                    onTap: () async {
                                      Navigator.pop(context);
                                      await downloadFile(context, entity as FsFile);
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text("Downloaded ${entity.basename}"),
                                          backgroundColor: Colors.green));
                                      selectedEntities.clear();
                                      browserProvider.manualRebuild();
                                    },
                                    leading: const Icon(Icons.download))));
                          }
                        }
                        menuOptions.add(PopupMenuItem(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ListTile(
                                minLeadingWidth: 24,
                                horizontalTitleGap: 8,
                                minVerticalPadding: 0,
                                dense: true,
                                title: Text("Delete Item${selectedEntities.length == 1 ? '' : 's'}"),
                                onTap: () async {
                                  Navigator.pop(context);
                                  HapticFeedback.vibrate();
                                  for (final entity in selectedEntities) {
                                    try {
                                      await browserProvider.controller.delete(entity);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
                                    }
                                  }
                                  selectedEntities.clear();
                                  browserProvider.manualRebuild();
                                },
                                leading: const Icon(Icons.delete))));

                        if (selectedEntities.where((e) => e.isDirectory()).isEmpty &&
                            browserProvider.controller.isLocal()) {
                          menuOptions.add(PopupMenuItem(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: ListTile(
                                  minLeadingWidth: 24,
                                  horizontalTitleGap: 8,
                                  minVerticalPadding: 0,
                                  dense: true,
                                  title: const Text("Share"),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    final paths = selectedEntities.map((e) => e.path).toList();
                                    Share.shareFiles(paths);
                                    selectedEntities.clear();
                                    browserProvider.manualRebuild();
                                  },
                                  leading: const Icon(Icons.share))));
                        }
                      }

                      return menuOptions;
                    })
              ],
              title: selectedEntities.isEmpty ? const Text("File Rover") : Text('${selectedEntities.length} selected'),
              bottom: const PathBar(),
            ),
            body: AnimatedContainer(
              margin: const EdgeInsets.all(10),
              duration: const Duration(milliseconds: 1000),
              child: FileList(
                builder: (context, snapshot) {
                  final List<FsEntity> entities = snapshot;
                  return ListView.builder(
                    itemCount: entities.length,
                    itemBuilder: (context, index) {
                      FsEntity entity = entities[index];
                      return ListTile(
                        minLeadingWidth: 8,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        horizontalTitleGap: 8,
                        minVerticalPadding: 1,
                        dense: true,
                        enableFeedback: true,
                        selected: browserProvider.selectedContains(entity),
                        leading: entity.isDirectory()
                            ? const Icon(Icons.folder, size: 48)
                            : FileIcon(entity.basename, size: 48),
                        title: Text(entity.basename, overflow: TextOverflow.ellipsis),
                        subtitle: Text(getSubTitle(entity)),
                        trailing: selectedEntities.isNotEmpty
                            ? browserProvider.selectedContains(entity)
                                ? const Icon(Icons.check_box)
                                : const Icon(Icons.check_box_outline_blank)
                            : null,
                        onTap: () {
                          if (selectedEntities.isNotEmpty) {
                            browserProvider.selectedContains(entity)
                                ? browserProvider.removeSelected(entity)
                                : browserProvider.addSelected(entity);
                          } else {
                            entity.isDirectory()
                                ? browserProvider.openDirectory(entity as FsDirectory)
                                : OpenFile.open(entity.path);
                          }
                        },
                        onLongPress: () => browserProvider.addSelected(entity),
                      );
                    },
                  );
                },
              ),
            )));
  }
}
