import 'package:file_rover/models/connection.dart';
import 'package:file_rover/providers/session.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../providers/browser.dart';
import '../widgets/add_storage.dart';

class SelectStorage extends StatelessWidget {
  const SelectStorage({Key? key}) : super(key: key);

  ListTile buildTile(BuildContext ctx, SftpConnection connection) {
    final sessionProvider = Provider.of<SessionProvider>(ctx, listen: false);
    final browserProvider = Provider.of<BrowserProvider>(ctx, listen: false);
    final name = '${connection.credential.username}@${connection.credential.host}';

    return ListTile(
      minLeadingWidth: 8,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      horizontalTitleGap: 8,
      enableFeedback: true,
      leading: const Icon(Icons.storage, size: 48),
      title: Text(name, overflow: TextOverflow.ellipsis),
      subtitle: Text(connection.isConnected ? "Connected" : "Disconnected"),
      onTap: () async {
        showDialog(context: ctx, builder: (_) => const Center(child: CircularProgressIndicator()));
        browserProvider.controller = await connection.getController();
        await browserProvider.openDefaultMountLocation();
        sessionProvider.manualRebuild();
        Navigator.pop(ctx);
        Navigator.pushNamed(ctx, '/browser');
      },
      onLongPress: () {
        showDialog(
            context: ctx,
            builder: (_) =>
                Dialog(
                  child: SingleChildScrollView(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      ListTile(
                          leading: const Icon(Icons.delete),
                          title: const Text("Delete"),
                          onTap: () {
                            sessionProvider.removeConnection(connection);
                            Navigator.pop(ctx);
                          }),
                    ]),
                  ),
                ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    final browserProvider = Provider.of<BrowserProvider>(context, listen: false);

    final items = [
      Card(
        child: ListTile(
          minLeadingWidth: 8,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          horizontalTitleGap: 8,
          enableFeedback: true,
          leading: const Icon(Icons.phone_android, size: 48),
          title: const Text("Local Storage", overflow: TextOverflow.ellipsis),
          onTap: () async {
            browserProvider.controller = sessionProvider.localController;
            await browserProvider.openDefaultMountLocation();
            Navigator.pushNamed(context, '/browser');
          },
        ),
      )
    ];
    for (final conn in sessionProvider.connections) {
      final card = Card(child: buildTile(context, conn));
      items.add(card);
    }

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () => showDialog(context: context, builder: (context) => const AddConnectionWidget()),
                icon: const Icon(Icons.add)),
          ],
          title: const Text("File Rover"),
        ),
        body: AnimatedContainer(
            padding: const EdgeInsets.all(20),
            duration: const Duration(milliseconds: 1000),
            child: ListView(children: items)));
  }
}
