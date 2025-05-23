import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes_script/database/db_helper.dart';
import 'package:notes_script/view/screens/note_description_screen.dart';
import 'package:path/path.dart';

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
  Color getRandomColor() {
    final Random random = Random();
    final int red = (random.nextInt(128) + 127);
    final int green = (random.nextInt(128) + 127);
    final int blue = (random.nextInt(128) + 127);
    return Color.fromARGB(255, red, green, blue);
  }

  void fetchNotes() async {
    noteList = await dbHelper!.fetchData();
    noteColors = List.generate(noteList.length, (_) => getRandomColor());

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper.getInstance();
    fetchNotes();
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
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => buildBottomSheet(context, () {
                dbHelper!.addNote(
                    title: titleController.text,
                    description: descriptionController.text);
                Navigator.of(context).pop();
                fetchNotes();
              }),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: noteList.isNotEmpty
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
                            child: Text(
                              notes[DBHelper.NOTE_TITLE],
                              style: TextStyle(fontSize: 20),
                              maxLines: 2,
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
                                        dbHelper!.deleteNote(
                                            notes[DBHelper.NOTE_ID]);
                                        fetchNotes();
                                        Navigator.of(context).pop();
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
                              size: 18,
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
              ));
  }

  Widget buildBottomSheet(BuildContext context, Function onTap) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add a Note',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 40,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      side: BorderSide(color: Colors.grey),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      onTap();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                    ),
                    child: const Text("Save"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
