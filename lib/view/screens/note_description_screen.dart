import 'package:flutter/material.dart';
import 'package:notes_script/database/db_helper.dart';

class NoteDescriptionScreen extends StatefulWidget {
  const NoteDescriptionScreen({super.key, required this.noteData});
  final Map<String, dynamic> noteData;

  @override
  State<NoteDescriptionScreen> createState() => _NoteDescriptionScreenState();
}

class _NoteDescriptionScreenState extends State<NoteDescriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Container(
          decoration: BoxDecoration(
              color: Colors.white24, borderRadius: BorderRadius.circular(12)),
          child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12)),
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.edit_note,
                    color: Colors.white,
                  )),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 50, right: 12, left: 12),
        child: Column(
          children: [
            Text(
              widget.noteData[DBHelper.NOTE_TITLE],
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              widget.noteData[DBHelper.NOTE_DESCRIPTION],
              style: TextStyle(fontSize: 15, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
