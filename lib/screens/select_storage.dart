import 'package:file_rover/fs/backends/local/controller.dart';
import 'package:file_rover/fs/backends/sftp/controller.dart';
import 'package:file_rover/providers/session.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../providers/browser.dart';
import '../widgets/add_storage.dart';

class SelectStorage extends StatelessWidget {
  const SelectStorage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    final browserProvider = Provider.of<BrowserProvider>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () => showDialog(context: context, builder: (context) => const AddStorageWidget()),
                icon: const Icon(Icons.add)),
          ],
          title: const Text("File Rover"),
        ),
        body: AnimatedContainer(
          padding: const EdgeInsets.all(10),
          duration: const Duration(milliseconds: 1000),
          child: ListView.builder(
              itemCount: sessionProvider.controllers.length,
              itemBuilder: (context, index) {
                final controller = sessionProvider.controllers[index];
                if (controller is LocalFsController) {
                  return Card(
                    child: ListTile(
                      minLeadingWidth: 8,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                      horizontalTitleGap: 8,
                      enableFeedback: true,
                      leading: const Icon(Icons.phone_android, size: 48),
                      title: const Text("Local Storage", overflow: TextOverflow.ellipsis),
                      onTap: () {
                        browserProvider.controller = controller;
                        Navigator.pushNamed(context, '/browser');
                      },
                    ),
                  );
                } else if (controller is SftpFsController) {
                  return Card(
                    child: ListTile(
                      minLeadingWidth: 8,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                      horizontalTitleGap: 8,
                      enableFeedback: true,
                      leading: const Icon(Icons.storage_sharp, size: 48),
                      title: Text(controller.getIdentity(), overflow: TextOverflow.ellipsis),
                      onTap: () {
                        browserProvider.controller = controller;
                        Navigator.pushNamed(context, '/browser');
                      },
                    ),
                  );
                } else {
                  return Card(
                    child: ListTile(
                      minLeadingWidth: 8,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                      horizontalTitleGap: 8,
                      enableFeedback: true,
                      leading: const Icon(Icons.question_mark_sharp, size: 48),
                      title: Text(controller.getIdentity(), overflow: TextOverflow.ellipsis),
                      onTap: () {
                        browserProvider.controller = controller;
                        Navigator.pushNamed(context, '/browser');
                      },
                    ),
                  );
                }
              }),
        ));
  }
}
