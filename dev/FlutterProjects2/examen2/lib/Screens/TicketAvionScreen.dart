import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:examen2/Models/TicketAvion.dart';

class TicketAvionScreen extends StatefulWidget {
  const TicketAvionScreen({super.key});

  @override
  _TicketAvionScreenState createState() => _TicketAvionScreenState();
}

class _TicketAvionScreenState extends State<TicketAvionScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets de Avión'),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('TicketAvion').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          return ListView(
            padding: const EdgeInsets.all(8.0),
            children: snapshot.data!.docs.map((document) {
              TicketAvion ticket = TicketAvion.fromMap(document.data() as Map<String, dynamic>, document.id);
              String formattedDate = DateFormat('yyyy-MM-dd').format(ticket.fecha);
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    ticket.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                          text: 'Destino: ',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          children: [
                            TextSpan(
                              text: ticket.destino,
                              style: const TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Fecha: ',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          children: [
                            TextSpan(
                              text: formattedDate,
                              style: const TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editTicket(ticket),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTicket(ticket.id),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createTicket,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _createTicket() {
    showDialog(
      context: context,
      builder: (context) {
        String nombre = '';
        String destino = '';
        DateTime fecha = DateTime.now();

        return AlertDialog(
          title: const Text('Crear Ticket'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => nombre = value,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                onChanged: (value) => destino = value,
                decoration: const InputDecoration(labelText: 'Destino'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: fecha,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != fecha) {
                    setState(() {
                      fecha = pickedDate;
                    });
                  }
                },
                child: const Text('Seleccionar Fecha'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _firestore.collection('TicketAvion').add({
                  'nombre': nombre,
                  'destino': destino,
                  'fecha': fecha,
                });
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _editTicket(TicketAvion ticket) {
    showDialog(
      context: context,
      builder: (context) {
        String nombre = ticket.nombre;
        String destino = ticket.destino;
        DateTime fecha = ticket.fecha;

        return AlertDialog(
          title: const Text('Editar Ticket'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => nombre = value,
                decoration: const InputDecoration(labelText: 'Nombre'),
                controller: TextEditingController(text: nombre),
              ),
              TextField(
                onChanged: (value) => destino = value,
                decoration: const InputDecoration(labelText: 'Destino'),
                controller: TextEditingController(text: destino),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: fecha,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != fecha) {
                    setState(() {
                      fecha = pickedDate;
                    });
                  }
                },
                child: const Text('Seleccionar Fecha'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _firestore.collection('TicketAvion').doc(ticket.id).update({
                  'nombre': nombre,
                  'destino': destino,
                  'fecha': fecha,
                });
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTicket(String id) {
    _firestore.collection('TicketAvion').doc(id).delete();
  }
}
