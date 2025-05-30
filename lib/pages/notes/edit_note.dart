// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/my_method.dart';
import '../home_page.dart';

class EditNotePage extends StatefulWidget {
  final String title;
  final String note;
  final String id;
  const EditNotePage({
    super.key,
    required this.title,
    required this.note,
    required this.id,
  });

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Note',
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.green.shade900,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: ElevatedButton(
              onPressed: () async {
                await _addNote(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('SAVE'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                border: InputBorder.none,
              ),
              cursorColor: Colors.black,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                maxLines: null,
                controller: noteController,
                decoration: const InputDecoration(
                  hintText: 'Note',
                  border: InputBorder.none,
                ),
                cursorColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  late final TextEditingController titleController;
  late final TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    noteController = TextEditingController(text: widget.note);
  }

  MyMethods myMethods = MyMethods();

  _addNote(BuildContext context) {
    myMethods.checkConnectivity(context);
    if (titleController.text.trim().isEmpty) {
      myMethods.displaySnackBar('Please enter title', Colors.red, context);
    } else {
      _saveNoteToFirestore(context);
    }
  }

  _saveNoteToFirestore(BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore
          .collection('shops')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('notes')
          .doc(widget.id) // Assuming the title is used as the document ID
          .set({
        'title': titleController.text.trim(),
        'note': noteController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // Use SetOptions to merge with existing data
    } catch (e) {
      myMethods.displaySnackBar(
          "Error while updating data: ${e.toString()}", Colors.red, context);
    }
  }
}
