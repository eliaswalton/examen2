import 'package:crud/Services/firestore.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Firestoreservice firestoreservice = Firestoreservice();

  final TextEditingController textcontroller = TextEditingController();
  void openNoteBox({String? id}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textcontroller,
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (id == null) {
                        firestoreservice.createNote(textcontroller.text);
                      } else {
                        firestoreservice.updateNote(id, textcontroller.text);
                      }
                      textcontroller.clear();
                      Navigator.pop(context);
                    },
                    child: const Text("Add"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('CRUD Basico'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: openNoteBox,
            child: const Icon(Icons.add),
          ),
          body: StreamBuilder(
              stream: firestoreservice.getNotesStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    String id = snapshot.data!.docs[index].id;
                    return Dismissible(
                        key: Key(snapshot.data!.docs[index].id),
                        onDismissed: (_) {
                          firestoreservice.deleteNote(snapshot.data!.docs[index].id);
                        },
                        
                        child: Card(
                          child: ListTile(
                            title: Text(snapshot.data!.docs[index]['Nota']),
                            trailing: Row(mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                              onPressed: () => openNoteBox(id: id),
                              icon: const Icon(Icons.settings),
                            ),
                              IconButton(
                                  onPressed: () {
                                    firestoreservice
                                        .deleteNote(snapshot.data!.docs[index].id);
                                  },
                                  icon: const Icon(Icons.delete))
                            ],
                            ),
                          ),
                        ));
                  },
                );
              })),
    );
  }
}
