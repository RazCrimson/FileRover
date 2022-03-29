import 'dart:io';

import 'package:file_rover/widgets/app_back_button.dart';
import 'package:file_rover/widgets/browser_back_button.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

import '../fs/utils.dart';
import '../providers/storage_path.dart';
import '../widgets/create_directory.dart';
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

  void createCreateDirectoryDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const CreateDirectoryWidget());
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
                            onPressed: () => createCreateDirectoryDialog(context),
                            icon: const Icon(Icons.create_new_folder_outlined)),
                        IconButton(onPressed: () => createSortDialog(context), icon: const Icon(Icons.sort_rounded)),
                        IconButton(
                            onPressed: () => createSelectStorageDialog(context),
                            icon: const Icon(Icons.sd_storage_rounded))
                      ],
                      title: Text(storagePathProvider.path.split('/').last),
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
                                  leading: FileSystemUtils.isFile(entity)
                                      ? const Icon(Icons.feed_outlined)
                                      : const Icon(Icons.folder),
                                  title: Text(FileSystemUtils.basename(entity)),
                                  subtitle: subtitle(entity),
                                  onTap: () async {
                                    if (FileSystemUtils.isDirectory(entity)) {
                                      // Open the Directory
                                      storagePathProvider.openDirectory(entity as Directory);
                                    } else {
                                      // Open the File
                                      OpenFile.open(entity.path);
                                    }
                                  },
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
            subtitle += "   Size: ${FileSystemUtils.formatSizeToReadable(size)}";
          }
        }
        return Text(subtitle);
      },
    );
  }
}
