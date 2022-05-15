import 'package:sqflite/sqflite.dart';

import '../models/credential.dart';

class CredentialDB {
  static const _name = "fileRover.db";
  static const _version = 1;

  late Database database;
  static const tableName = 'credential';

  initDatabase() async {
    database = await openDatabase(_name, version: _version, onCreate: (Database db, int version) async {
      await db.execute('''
            CREATE TABLE $tableName (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              username TEXT,
              password TEXT,
              host TEXT,
              port INT
            )
          ''');
    });
  }

  Future<int> insert(Credential cred) async {
    return await database.insert(tableName, cred.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> update(Credential cred) async {
    return await database.update(tableName, cred.toMap(),
        where: 'id = ?', whereArgs: [cred.id], conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Credential>> fetchAll() async {
    final records = await database.query(tableName);
    return records.map((record) => Credential.fromMap(record)).toList();
  }

  Future<Credential?> getNotes(int id) async {
    final records = await database.query(tableName, where: 'id = ?', whereArgs: [id]);
    if (records.isNotEmpty) return Credential.fromMap(records.first);
    return null;
  }

  Future<int> deleteNode(int id) async {
    return await database.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  closeDatabase() async {
    await database.close();
  }
}
