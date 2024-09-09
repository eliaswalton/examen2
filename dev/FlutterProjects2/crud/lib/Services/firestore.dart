import 'package:cloud_firestore/cloud_firestore.dart';

class Firestoreservice {
  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  //create new note
  Future createNote(String note) async {
    try {
      await notes.add({
        'Nota': note,
        'timestamp': Timestamp.now()
      });
    } catch (e) {
      print(e);
    }
  }

  //READ: get notes from database
  Stream<QuerySnapshot<Object?>> getNotesStream() {
    return notes.orderBy('timestamp', descending: true).snapshots();
  } 

  //UPDATE: update note
  Future updateNote(String id, String note) async {
    try {
      return await notes.doc(id).update({'Nota': note});
    } catch (e) {
      print(e);
    }
  }

  //DELETE: delete note
  Future deleteNote(String id) async {
    try {
      return await notes.doc(id).delete();
    } catch (e) {
      print(e);
    }
  }
}