import 'package:notes_script/database/db_helper.dart';

class NoteModel {
  NoteModel({this.id, this.title, this.description, this.createdAt});
  int? id;
  String? title;
  String? description;
  String? createdAt;

  // Conversion Map to model
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map[DBHelper.NOTE_ID],
      title: map[DBHelper.NOTE_TITLE],
      description: map[DBHelper.NOTE_DESCRIPTION],
      createdAt: map[DBHelper.NOTE_CREATED_AT],
    );
  }

//Conversion model to map
  Map<String, dynamic> toMap() {
    return {
      DBHelper.NOTE_TITLE: title,
      DBHelper.NOTE_DESCRIPTION: description,
      DBHelper.NOTE_CREATED_AT: createdAt,
    };
  }
}
