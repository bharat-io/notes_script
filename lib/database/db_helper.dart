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
      $NOTE_TITLE TEXT NOT NULL,
      $NOTE_DESCRIPTION TEXT NOT NULL
      )

      ''');
    });
  }

  void addNote({required String title, required String description}) async {
    var db = await initDB();
    await db.insert(
      NOTE_TABLE,
      {NOTE_TITLE: title, NOTE_DESCRIPTION: description},
    );
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    var db = await initDB();
    return db.query(NOTE_TABLE);
  }

  Future<int> deleteNote(int id) async {
    var db = await initDB();
    return db.delete(NOTE_TABLE, where: "$NOTE_ID=?", whereArgs: [id]);
  }
}
