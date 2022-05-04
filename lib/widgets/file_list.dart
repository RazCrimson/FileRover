import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../fs/local.dart';
import '../providers/sort.dart';
import '../providers/storage_path.dart';

typedef _Builder = Widget Function(
  BuildContext context,
  List<FileSystemEntity> snapshot,
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

    return FutureBuilder<List<Directory>?>(
      future: LocalFsController.getStorageList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _body(context);
        } else if (snapshot.hasError) {
          if (kDebugMode) {
            print(snapshot.error);
          }
          return _errorPage(snapshot.error.toString());
        } else {
          return _loadingScreenWidget();
        }
      },
    );
  }

  Widget _body(BuildContext context) {
    final sortProvider = Provider.of<SortProvider>(context);
    final storagePathProvider = Provider.of<StoragePathProvider>(context);

    return FutureBuilder<List<FileSystemEntity>>(
        future:
            LocalFsController.getSortedEntities(storagePathProvider.path, sortProvider.sortBy, sortProvider.sortOrder),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<FileSystemEntity> entities = snapshot.data!;
            if (entities.isEmpty) {
              return _emptyFolderWidget();
            }
            if (widget.hideHiddenEntity) {
              entities = entities.where((element) {
                if (LocalFsController.basename(element) == "" || LocalFsController.basename(element).startsWith('.')) {
                  return false;
                } else {
                  return true;
                }
              }).toList();
            }
            return widget.builder(context, entities);
          } else if (snapshot.hasError) {
            if (kDebugMode) {
              print(snapshot.error);
            }
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
