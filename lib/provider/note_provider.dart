import 'package:flutter/material.dart';
import 'package:notes_script/database/db_helper.dart';

class NoteProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _noteList = [];
  List<Map<String, dynamic>> getNotesList() => _noteList;
  DBHelper dbHelper = DBHelper.getInstance();

  void fetchNotes() async {
    _noteList = await dbHelper.fetchData();
    print(_noteList);
    notifyListeners();
  }

  void addNotes(
      {required String noteTitle, required String noteDescription}) async {
    bool check =
        await dbHelper.addData(title: noteTitle, description: noteDescription);
    if (check) {
      fetchNotes();
    }
  }

  void updateNotes(
      {required int noteId,
      required String noteTitle,
      required String noteDescription}) async {
    bool check = await dbHelper.updateData(
        id: noteId, title: noteTitle, description: noteDescription);
    if (check) {
      fetchNotes();
    }
  }

  void deleteNotes({required int noteId}) async {
    bool check = await dbHelper.deleteData(noteId);
    if (check) {
      fetchNotes();
    }
  }
}
