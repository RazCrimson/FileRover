import 'package:file_icon/file_icon.dart';
import 'package:file_rover/fs/contracts/directory.dart';
import 'package:file_rover/fs/contracts/entity.dart';
import 'package:file_rover/widgets/browser_back_handler.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

import '../providers/current_directory.dart';
import '../widgets/create_directory.dart';
import '../widgets/entity_context_menu.dart';
import '../widgets/file_list.dart';
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
    final currentDirectory = Provider.of<CurrentDirectory>(context, listen: false);

    return BrowserBackHandler(
        child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () => showDialog(context: context, builder: (context) => const CreateDirectoryWidget()),
                    icon: const Icon(Icons.create_new_folder_outlined)),
                IconButton(
                    onPressed: () => showDialog(context: context, builder: (context) => const SortWidget()),
                    icon: const Icon(Icons.sort_rounded)),
                IconButton(
                    onPressed: () => showDialog(context: context, builder: (context) => const SelectStorageWidget()),
                    icon: const Icon(Icons.sd_storage_rounded))
              ],
              title: const Text("File Rover"),
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
                      return Card(
                        child: ListTile(
                          minLeadingWidth: 8,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          horizontalTitleGap: 8,
                          minVerticalPadding: 1,
                          dense: true,
                          enableFeedback: true,
                          leading: entity.isDirectory()
                              ? const Icon(Icons.folder, size: 48)
                              : FileIcon(entity.basename, size: 48),
                          title: Text(entity.basename, overflow: TextOverflow.ellipsis),
                          subtitle: Text(getSubTitle(entity)),
                          onTap: () async {
                            if (entity.isDirectory()) {
                              // Open the Directory
                              currentDirectory.openDirectory(entity as FsDirectory);
                            } else {
                              // Open the File
                              OpenFile.open(entity.path);
                            }
                          },
                          onLongPress: () =>
                              showDialog(context: context, builder: (context) => EntityContextMenu(entity: entity)),
                        ),
                      );
                    },
                  );
                },
              ),
            )));
  }
}
