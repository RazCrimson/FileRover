import 'dart:io';

import 'package:file_rover/providers/storage_path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../fs/local.dart';

class SelectStorageWidget extends StatelessWidget {
  const SelectStorageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storagePathProvider = Provider.of<StoragePathProvider>(context, listen: false);

    return Dialog(
      child: FutureBuilder<List<Directory>>(
        future: LocalFsController.getStorageList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<FileSystemEntity> storageList = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: storageList
                      .map((e) => ListTile(
                            title: Text(LocalFsController.basename(e)),
                            onTap: () {
                              storagePathProvider.openDirectory(e as Directory);
                              Navigator.pop(context);
                            },
                          ))
                      .toList()),
            );
          }
          return const Dialog(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
