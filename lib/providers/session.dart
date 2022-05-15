import 'package:file_rover/dao/credential.dart';
import 'package:flutter/material.dart';

import '../fs/backends/local/controller.dart';
import '../models/connection.dart';
import '../models/credential.dart';

class SessionProvider with ChangeNotifier {
  bool initialized = false;
  final CredentialDB credDb;
  final LocalFsController _localFsController;
  late List<SftpConnection> _connections = [];

  SessionProvider(this.credDb, this._localFsController) {
    init().then((_) => notifyListeners());
  }

  Future<void> init() async {
    if (!initialized) {
      await credDb.initDatabase();
      final credentials = await credDb.fetchAll();
      _connections = credentials.map((cred) => SftpConnection(cred)).toList();
      initialized = true;
    }
  }

  LocalFsController get localController => _localFsController;

  List<SftpConnection> get connections => _connections;

  Future<void> addCredential(Credential credential) async {
    credDb.insert(credential);
    _connections.add(SftpConnection(credential));
    notifyListeners();
  }

  bool removeConnection(SftpConnection connection) {
    _connections.removeWhere((e) => e == connection);
    credDb.deleteNode(connection.credential.id!);
    notifyListeners();
    return true;
  }

  void manualRebuild() {
    notifyListeners();
  }
}
