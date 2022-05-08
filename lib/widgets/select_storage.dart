import 'package:file_rover/fs/contracts/entity.dart';
import 'package:file_rover/providers/current_directory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../fs/contracts/directory.dart';
import '../providers/current_controller.dart';

class SelectStorageWidget extends StatelessWidget {
  const SelectStorageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentController = Provider.of<CurrentController>(context, listen: false);
    final currentDirectory = Provider.of<CurrentDirectory>(context, listen: false);

    return Dialog(
      child: FutureBuilder<List<FsEntity>>(
        future: currentController.controller?.getMountsLocations(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<FsEntity> storageList = snapshot.data ?? [];
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: storageList
                      .map((entity) => ListTile(
                            title: Text(entity.basename),
                            onTap: () {
                              currentDirectory.openDirectory(entity as FsDirectory);
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
