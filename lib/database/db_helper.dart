import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();
  static DBHelper getInstance() {
    return DBHelper._();
  }

  Database? database;
  static const DB_NAME = "note.db";
  static const NOTE_TABLE = "note";
  static const NOTE_ID = "id";
  static const NOTE_TITLE = "title";
  static const NOTE_DESCRIPTION = "description";
  static const NOTE_CREATED_AT = "created_at";

  Future<Database> initDB() async {
    if (database == null) {
      database = await openDB();
      return database!;
    } else {
      return database!;
    }
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbpath = join(appDir.path, DB_NAME);
    return openDatabase(dbpath, version: 1,
        onCreate: (Database db, int version) {
      return db.execute('''
      CREATE TABLE $NOTE_TABLE(
      $NOTE_ID INTEGER PRIMARY  KEY AUTOINCREMENT,
      $NOTE_CREATED_AT Text NOT NULL,
      $NOTE_TITLE TEXT NOT NULL,
      $NOTE_DESCRIPTION TEXT NOT NULL
      )

      ''');
    });
  }

  Future<bool> addData(
      {required String title, required String description}) async {
    var db = await initDB();
    int rowsEffected = await db.insert(
      NOTE_TABLE,
      {
        NOTE_TITLE: title,
        NOTE_DESCRIPTION: description,
        NOTE_CREATED_AT: DateTime.now().toString()
      },
    );
    return rowsEffected > 0;
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    var db = await initDB();
    return db.query(NOTE_TABLE);
  }

  Future<bool> deleteData(int id) async {
    var db = await initDB();
    int rowsEffected =
        await db.delete(NOTE_TABLE, where: "$NOTE_ID=?", whereArgs: [id]);
    return rowsEffected > 0;
  }

  Future<bool> updateData(
      {required int id,
      required String title,
      required String description}) async {
    var db = await initDB();
    int rowsEffected = await db.update(
        NOTE_TABLE, {NOTE_TITLE: title, NOTE_DESCRIPTION: description},
        where: "$NOTE_ID=?", whereArgs: [id]);
    return rowsEffected > 0;
  }
}
