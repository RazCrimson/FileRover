import 'package:file_rover/fs/contracts/directory.dart';
import 'package:file_rover/fs/contracts/entity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/current_controller.dart';
import '../providers/sort_options.dart';
import '../providers/current_directory.dart';

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
    final currentController = Provider.of<CurrentController>(context, listen: false);

    return FutureBuilder<List<FsDirectory>>(
      future: currentController.controller?.getMountsLocations(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _body(context);
        } else if (snapshot.hasError) {
          if (kDebugMode) print(snapshot.error);
          return _errorPage(snapshot.error.toString());
        } else {
          return _loadingScreenWidget();
        }
      },
    );
  }

  Widget _body(BuildContext context) {
    final sortOptions = Provider.of<SortOptions>(context);
    final currentDir = Provider.of<CurrentDirectory>(context).directory;
    final fsController = Provider.of<CurrentController>(context).controller;

    if(fsController == null || currentDir == null) return Container();

    return FutureBuilder<List<FsEntity>>(
        future: fsController.getSortedEntities(currentDir, sortOptions.sortBy, sortOptions.sortOrder),
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
