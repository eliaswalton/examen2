import 'package:examen2/Screens/TicketAvionScreen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final GoRouter _router = GoRouter(routes: [

    GoRoute(
      path: '/', 
      builder: (context, state) => TicketAvionScreen()
      ),
  ]
    
  );

  MainApp({super.key});
  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
