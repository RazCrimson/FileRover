import 'package:file_rover/fs/contracts/entity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../fs/contracts/directory.dart';
import '../providers/browser.dart';

class SelectStorageWidget extends StatelessWidget {
  const SelectStorageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final browserProvider = Provider.of<BrowserProvider>(context, listen: false);

    return Dialog(
      child: FutureBuilder<List<FsEntity>>(
        future: browserProvider.controller.getMountsLocations(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<FsEntity> storageList = snapshot.data ?? [];
            return SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: storageList
                      .map((entity) => ListTile(
                            title: Text(entity.basename),
                            onTap: () {
                              browserProvider.mountLocation = entity as FsDirectory;
                              Navigator.pop(context);
                            },
                          ))
                      .toList()),
            );
          }
          return const SizedBox(child: Center(child: CircularProgressIndicator()), height: 200, width: 200);
        },
      ),
    );
  }
}
