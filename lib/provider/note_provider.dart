import 'package:flutter/material.dart';
import 'package:notes_script/database/db_helper.dart';
import 'package:notes_script/database/model/note_model.dart';

class NoteProvider extends ChangeNotifier {
  List<NoteModel> _noteList = [];
  List<NoteModel> getNotesList() => _noteList;
  DBHelper dbHelper = DBHelper.getInstance();

  void fetchNotes() async {
    _noteList = await dbHelper.fetchData();
    notifyListeners();
  }

  void addNotes(
      {required String noteTitle,
      required String noteDescription,
      required String createdAt}) async {
    bool check = await dbHelper.addData(
        noteModel: NoteModel(
            title: noteTitle,
            description: noteDescription,
            createdAt: createdAt));
    if (check) {
      fetchNotes();
    }
  }

  void updateNotes(
      {required int noteId,
      required String noteTitle,
      required String noteDescription}) async {
    bool check = await dbHelper.updateData(
        noteModel: NoteModel(
            id: noteId, title: noteTitle, description: noteDescription));
    if (check) {
      fetchNotes();
    }
  }

  void deleteNotes({required int noteId}) async {
    bool check = await dbHelper.deleteData(noteModel: NoteModel(id: noteId));
    if (check) {
      fetchNotes();
    }
  }
}
