import 'dart:io';

import 'package:notes_script/database/model/note_model.dart';
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

  Future<bool> addData({required NoteModel noteModel}) async {
    var db = await initDB();
    int rowsEffected = await db.insert(NOTE_TABLE, noteModel.toMap());
    return rowsEffected > 0;
  }

  Future<List<NoteModel>> fetchData() async {
    var db = await initDB();
    List<Map<String, dynamic>> noteMapData = await db.query(NOTE_TABLE);
    List<NoteModel> noteList = [];

    for (int i = 0; i < noteMapData.length; i++) {
      NoteModel eachnoteModel = NoteModel.fromMap(noteMapData[i]);
      noteList.add(eachnoteModel);
    }
    return noteList;
  }

  Future<bool> deleteData({required NoteModel noteModel}) async {
    var db = await initDB();
    int rowsEffected = await db
        .delete(NOTE_TABLE, where: "$NOTE_ID=?", whereArgs: [noteModel.id]);
    return rowsEffected > 0;
  }

  Future<bool> updateData({required NoteModel noteModel}) async {
    var db = await initDB();
    int rowsEffected = await db.update(NOTE_TABLE,
        {NOTE_TITLE: noteModel.title, NOTE_DESCRIPTION: noteModel.description},
        where: "$NOTE_ID=?", whereArgs: [noteModel.id]);
    return rowsEffected > 0;
  }
}
