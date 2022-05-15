import 'package:file_rover/fs/contracts/entity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/browser.dart';

typedef _Builder = Widget Function(
  BuildContext context,
  List<FsEntity> snapshot,
);

class FileList extends StatefulWidget {
  /// For the loading screen, create a custom widget.

  final Widget? loadingScreen;

  /// Custom widget for an empty directory
  final Widget? emptyDirectory;

  final _Builder builder;

  /// Hide the files and folders that are hidden.
  final bool hideHiddenEntity;

  const FileList({
    Key? key,
    this.emptyDirectory,
    this.loadingScreen,
    required this.builder,
    this.hideHiddenEntity = true,
  }) : super(key: key);

  @override
  _FileListState createState() => _FileListState();
}

class _FileListState extends State<FileList> {
  @override
  Widget build(BuildContext context) {
    final browserProvider = Provider.of<BrowserProvider>(context);

    return FutureBuilder<List<FsEntity>>(
        future: browserProvider.getSortedEntitiesInCurrentDir(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<FsEntity> entities = snapshot.data ?? [];
            if (entities.isEmpty) return _emptyFolderWidget();
            if (widget.hideHiddenEntity) {
              entities = entities.where((entity) {
                if (entity.basename == "" || entity.basename.startsWith('.')) return false;
                return true;
              }).toList();
            }
            return widget.builder(context, entities);
          } else if (snapshot.hasError) {
            if (kDebugMode) {
              print(snapshot.error);
            }
            browserProvider.goToParentDirectory();
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(snapshot.error.toString()), backgroundColor: Colors.red));
            });
            return _errorPage(snapshot.error.toString());
          } else {
            return _loadingScreenWidget();
          }
        });
  }

  Widget _emptyFolderWidget() {
    if (widget.emptyDirectory == null) {
      return const Center(child: Text("Empty Directory"));
    }
    return widget.emptyDirectory!;
  }

  Container _errorPage(String error) {
    return Container(
      color: Colors.red,
      child: Center(
        child: Text("Error: $error"),
      ),
    );
  }

  Widget _loadingScreenWidget() {
    if (widget.loadingScreen == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Center(child: widget.loadingScreen);
  }
}
