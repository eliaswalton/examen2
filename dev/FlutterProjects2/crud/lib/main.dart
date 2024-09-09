import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void openNoteBox() {
    showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              content: TextField(),
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
      ),
    );
  }
}
