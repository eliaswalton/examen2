import 'package:flutter/material.dart';


class TicketAvionScreen extends StatelessWidget {
  const TicketAvionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Avion'),
      ),
      body: const Center(
        child: Text('Ticket Avion'),
      ),
    );
  }
}