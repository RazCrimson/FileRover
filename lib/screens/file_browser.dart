import 'dart:io';

import 'package:file_icon/file_icon.dart';
import 'package:file_rover/screens/utils.dart';
import 'package:file_rover/widgets/app_back_button.dart';
import 'package:file_rover/widgets/browser_back_button.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

import '../fs/local.dart';
import '../providers/storage_path.dart';
import '../widgets/create_directory.dart';
import '../widgets/entity_context_menu.dart';
import '../widgets/file_list.dart';
import '../widgets/select_storage.dart';
import '../widgets/sort_dialog.dart';

class FileBrowser extends StatelessWidget {
  const FileBrowser({Key? key}) : super(key: key);

  void createSortDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const SortWidget());
  }

  void createSelectStorageDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const SelectStorageWidget());
  }

  void createCreateDirectoryDialog(BuildContext context, String path) {
    showDialog(context: context, builder: (context) => CreateDirectoryWidget(path: path));
  }

  void createEntityContextMenu(BuildContext context, FileSystemEntity entity) {
    showDialog(context: context, builder: (context) => EntityContextMenu(entity: entity));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => StoragePathProvider("/storage/emulated/0"),
        child: Consumer<StoragePathProvider>(
            builder: (_, storagePathProvider, __) => AppBackButton(
                child: Scaffold(
                    appBar: AppBar(
                      actions: [
                        IconButton(
                            onPressed: () =>
                                constructDialog(context, CreateDirectoryWidget(path: storagePathProvider.path)),
                            icon: const Icon(Icons.create_new_folder_outlined)),
                        IconButton(
                            onPressed: () => constructDialog(context, const SortWidget()),
                            icon: const Icon(Icons.sort_rounded)),
                        IconButton(
                            onPressed: () => constructDialog(context, const SelectStorageWidget()),
                            icon: const Icon(Icons.sd_storage_rounded))
                      ],
                      title: const Text("File Rover"),
                      leading: const BrowserBackButton(),
                    ),
                    body: Container(
                      margin: const EdgeInsets.all(10),
                      child: FileList(
                        builder: (context, snapshot) {
                          final List<FileSystemEntity> entities = snapshot;
                          return ListView.builder(
                            itemCount: entities.length,
                            itemBuilder: (context, index) {
                              FileSystemEntity entity = entities[index];
                              return Card(
                                child: ListTile(
                                  leading: LocalFsController.isFile(entity)
                                      ? FileIcon(LocalFsController.basename(entity), size: 48)
                                      : const Icon(Icons.folder, size: 48),
                                  title: Text(LocalFsController.basename(entity)),
                                  subtitle: subtitle(entity),
                                  onTap: () async {
                                    if (LocalFsController.isDirectory(entity)) {
                                      // Open the Directory
                                      storagePathProvider.openDirectory(entity as Directory);
                                    } else {
                                      // Open the File
                                      OpenFile.open(entity.path);
                                    }
                                  },
                                  onLongPress: () => constructDialog(context, EntityContextMenu(entity: entity)),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    )))));
  }

  Widget subtitle(FileSystemEntity entity) {
    return FutureBuilder<FileStat>(
      future: entity.stat(),
      builder: (context, snapshot) {
        String subtitle = "";
        if (snapshot.hasData) {
          subtitle += "Modified: " + "${snapshot.data!.modified}".substring(0, 10);
          if (entity is File) {
            int size = snapshot.data!.size;
            subtitle += "   Size: ${LocalFsController.formatSizeToReadable(size)}";
          }
        }
        return Text(subtitle);
      },
    );
  }
}
