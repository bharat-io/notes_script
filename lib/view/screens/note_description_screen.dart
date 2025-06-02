import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_script/bottom_sheet.dart';
import 'package:notes_script/database/db_helper.dart';
import 'package:notes_script/provider/note_provider.dart';
import 'package:notes_script/view/screens/notes_screen.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class NoteDescriptionScreen extends StatefulWidget {
  const NoteDescriptionScreen(
      {super.key,
      required this.noteData,
      required this.titleController,
      required this.descriptionController});
  final Map<String, dynamic> noteData;
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  @override
  State<NoteDescriptionScreen> createState() => _NoteDescriptionScreenState();
}

class _NoteDescriptionScreenState extends State<NoteDescriptionScreen> {
  DBHelper? dbHelper;
  var date = DateFormat('dd-MMMM-yyyy');

  @override
  void initState() {
    super.initState();
  }

  void replaceAfterUdate(context) {
    Navigator.of(context).pop();
  }

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
                replaceAfterUdate(context);
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
                  onPressed: () {
                    widget.titleController.text =
                        widget.noteData[DBHelper.NOTE_TITLE] ?? '';
                    widget.descriptionController.text =
                        widget.noteData[DBHelper.NOTE_DESCRIPTION] ?? '';

                    showModalBottomSheet(
                        isScrollControlled: true,
                        isDismissible: false,
                        context: context,
                        builder: (context) => buildBottomSheet(context,
                                buttonText: "Update",
                                titleText: 'Edit', onTap: () {
                              context.read<NoteProvider>().updateNotes(
                                  noteId: widget.noteData[DBHelper.NOTE_ID],
                                  noteTitle: widget.titleController.text,
                                  noteDescription:
                                      widget.descriptionController.text);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                                titleController: widget.titleController,
                                descriptionController:
                                    widget.descriptionController));
                  },
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.noteData[DBHelper.NOTE_TITLE],
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            Text(
              date.format(
                  DateTime.parse(widget.noteData[DBHelper.NOTE_CREATED_AT])),
              style: TextStyle(color: Colors.white60),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      widget.noteData[DBHelper.NOTE_DESCRIPTION],
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
