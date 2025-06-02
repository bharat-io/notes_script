import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_script/bottom_sheet.dart';
import 'package:notes_script/database/db_helper.dart';
import 'package:notes_script/provider/note_provider.dart';
import 'package:notes_script/show_snackbar.dart';
import 'package:notes_script/view/screens/note_description_screen.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DBHelper? dbHelper;
  List<Map<String, dynamic>> noteList = [];
  List<Color> noteColors = [];
  var date = DateFormat('dd-MMMM-yyyy');
  Color getRandomColor() {
    final Random random = Random();
    final int red = (random.nextInt(128) + 127);
    final int green = (random.nextInt(128) + 127);
    final int blue = (random.nextInt(128) + 127);
    return Color.fromARGB(255, red, green, blue);
  }

  // void fetchNotes() async {
  //   noteList = await dbHelper!.fetchData();
  // }

  @override
  void initState() {
    super.initState();

    context.read<NoteProvider>().fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black12,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 17.0),
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ],
          title: Text(
            "Note Script",
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            showModalBottomSheet(
              isDismissible: false,
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => Container(
                child: buildBottomSheet(context,
                    titleText: 'Add ',
                    buttonText: "Add",
                    titleController: titleController,
                    descriptionController: descriptionController, onTap: () {
                  context.read<NoteProvider>().addNotes(
                      noteTitle: titleController.text,
                      noteDescription: descriptionController.text);

                  titleController.clear();
                  descriptionController.clear();
                  Navigator.of(context).pop();
                }),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: Consumer(builder: (ctx, provider, __) {
          noteList = ctx.watch<NoteProvider>().getNotesList();
          noteColors = List.generate(noteList.length, (_) => getRandomColor());
          print("Data on UI: $noteList");
          return noteList.isNotEmpty
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2,
                  ),
                  itemCount: noteList.length,
                  itemBuilder: (context, int index) {
                    var notes = noteList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => NoteDescriptionScreen(
                                        noteData: notes,
                                        titleController: titleController,
                                        descriptionController:
                                            descriptionController,
                                      )));
                            },
                            child: Container(
                              width: double.infinity,
                              height: 110,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: noteColors[index],
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    notes[DBHelper.NOTE_TITLE],
                                    style: TextStyle(fontSize: 20),
                                    maxLines: 2,
                                  ),
                                  Text(
                                    date
                                        .format(DateTime.parse(
                                            notes[DBHelper.NOTE_CREATED_AT]))
                                        .toString(),
                                    style: TextStyle(fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Warning!"),
                                    content: const Text(
                                        "Are you sure you want to delete this note"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context
                                              .read<NoteProvider>()
                                              .deleteNotes(
                                                  noteId:
                                                      notes[DBHelper.NOTE_ID]);
                                          Navigator.of(context).pop();
                                          showSnackBar(
                                              "Note deleted successful",
                                              context);
                                        },
                                        child: const Text("delete"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  })
              : Center(
                  child: Text(
                    "Notes not available to display",
                    style: TextStyle(color: Colors.white),
                  ),
                );
        }));
  }
}
