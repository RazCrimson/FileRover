import 'package:file_rover/fs/contracts/directory.dart';
import 'package:file_rover/widgets/select_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/browser.dart';

class PathBar extends StatelessWidget implements PreferredSizeWidget {
  final IconData? icon;

  const PathBar({
    Key? key,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final browserProvider = Provider.of<BrowserProvider>(context);

    FsDirectory dir = browserProvider.directory;
    final List<FsDirectory> pathNodes = [dir];
    while (dir.path != browserProvider.mountLocation.path) {
      dir = dir.parent;
      pathNodes.insert(0, dir);
    }

    return SizedBox(
      height: 50,
      child: Align(
          alignment: Alignment.centerLeft,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: pathNodes.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return InkWell(
                  onTap: () => showDialog(context: context, builder: (context) => const SelectStorageWidget()),
                  child: SizedBox(
                    height: 40,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          browserProvider.controller.getIdentity(),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                final FsDirectory directory = pathNodes[index - 1];

                return InkWell(
                  onTap: () => browserProvider.openDirectory(directory),
                  child: SizedBox(
                    height: 40,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          directory.basename,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Icon(Icons.chevron_right, color: Colors.white);
            },
          )),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40.0);
}
