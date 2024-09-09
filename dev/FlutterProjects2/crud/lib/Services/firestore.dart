import 'package:cloud_firestore/cloud_firestore.dart';

class Firestoreservice {
  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  //create new note
  Future createNote(String title, String content) async {
    try {
      await notes.add({
        'title': title,
        'content': content
      });
    } catch (e) {
      print(e);
    }
  }
}