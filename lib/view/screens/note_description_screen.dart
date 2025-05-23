import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_script/bottom_sheet.dart';
import 'package:notes_script/database/db_helper.dart';
import 'package:path/path.dart';

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
  var date = DateFormat.yMMMEd();

  @override
  void initState() {
    super.initState();
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
                                titleText: 'Edit', onTap: () async {
                              await DBHelper.getInstance().updateNote(
                                  id: widget.noteData[DBHelper.NOTE_ID],
                                  title: widget.titleController.text,
                                  description:
                                      widget.descriptionController.text);

                              setState(() {
                                widget.noteData[DBHelper.NOTE_TITLE] =
                                    widget.titleController.text;
                                widget.noteData[DBHelper.NOTE_DESCRIPTION] =
                                    widget.descriptionController.text;
                              });

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
