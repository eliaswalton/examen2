import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            children: snapshot.data!.docs.map((document) {
              TicketAvion ticket = TicketAvion.fromMap(document.data() as Map<String, dynamic>, document.id);
              return ListTile(
                title: Text(ticket.nombre),
                subtitle: Text('${ticket.destino} - ${ticket.fecha}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editTicket(ticket),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteTicket(ticket.id),
                    ),
                  ],
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
        title: Text('Crear Ticket'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => nombre = value,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              onChanged: (value) => destino = value,
              decoration: InputDecoration(labelText: 'Destino'),
            ),
            SizedBox(height: 20),
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
              child: Text('Seleccionar Fecha'),
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
            child: Text('Guardar'),
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
            // Agregar un selector de fecha aquí
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
