import 'package:examen2/Domains/DetallesTickets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:examen2/Models/TicketAvion.dart';


class TicketAvionScreen extends StatefulWidget {
  const TicketAvionScreen({super.key});

  @override
  _TicketAvionScreenState createState() => _TicketAvionScreenState();
}

class _TicketAvionScreenState extends State<TicketAvionScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Random _random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets de Avión'),
        backgroundColor: Colors.amber,
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
                color: Colors.amber[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    ticket.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.black),
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
                        icon: const Icon(Icons.edit, color: Color.fromARGB(255, 79, 156, 218)),
                        onPressed: () => _editTicket(ticket),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Color.fromARGB(255, 209, 71, 61)),
                        onPressed: () => _deleteTicket(ticket.id),
                      ),
                    ],
                  ),
                  onTap: () => showTicketDetails(context, ticket), 
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createTicket,
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _createTicket() {
    showDialog(
      context: context,
      builder: (context) {
        String nombre = '';
        String numeroVuelo = _generateRandomFlightNumber();
        String aerolinea = 'Avianca';
        String informacionPasajero = '';
        String origen = '';
        String destino = '';
        String asiento = _generateRandomSeat();
        String clase = 'Economy'; 
        DateTime fecha = DateTime.now();

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Crear Ticket'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) => nombre = value,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                    DropdownButton<String>(
                      value: aerolinea,
                      onChanged: (String? newValue) {
                        setState(() {
                          aerolinea = newValue!;
                        });
                      },
                      items: <String>[
                        'Avianca',
                        'Copa Airlines',
                        'CM Airlines',
                        'Volaris',
                        'United Airlines',
                        'Spirit Airlines',
                        'Delta Airlines'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    TextField(
                      onChanged: (value) => informacionPasajero = value,
                      decoration: const InputDecoration(labelText: 'ID del Pasajero'),
                    ),
                    TextField(
                      onChanged: (value) => origen = value,
                      decoration: const InputDecoration(labelText: 'Origen'),
                    ),
                    TextField(
                      onChanged: (value) => destino = value,
                      decoration: const InputDecoration(labelText: 'Destino'),
                    ),
                    TextField(
                      onChanged: (value) => asiento = value,
                      decoration: const InputDecoration(labelText: 'Asiento'),
                    ),
                    const SizedBox(height: 20),
                    DropdownButton<String>(
                      value: clase,
                      onChanged: (String? newValue) {
                        setState(() {
                          clase = newValue!;
                        });
                      },
                      items: <String>['Economy', 'Premium Economy', 'Business', 'First Class']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
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
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _firestore.collection('TicketAvion').add({
                      'nombre': nombre,
                      'numeroVuelo': numeroVuelo,
                      'aerolinea': aerolinea,
                      'informacionPasajero': informacionPasajero,
                      'origen': origen,
                      'destino': destino,
                      'asiento': asiento,
                      'clase': clase,
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
      },
    );
  }

  void _editTicket(TicketAvion ticket) {
    showDialog(
      context: context,
      builder: (context) {
        String nombre = ticket.nombre;
        String numeroVuelo = ticket.numeroVuelo;
        String aerolinea = ticket.aerolinea;
        String informacionPasajero = ticket.informacionPasajero;
        String origen = ticket.origen;
        String destino = ticket.destino;
        String asiento = ticket.asiento;
        String clase = ticket.clase;
        DateTime fecha = ticket.fecha;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Editar Ticket'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) => nombre = value,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      controller: TextEditingController(text: nombre),
                    ),
                    TextField(
                      onChanged: (value) => numeroVuelo = value,
                      decoration: const InputDecoration(labelText: 'Número de Vuelo'),
                      controller: TextEditingController(text: numeroVuelo),
                    ),
                    DropdownButton<String>(
                      value: aerolinea,
                      onChanged: (String? newValue) {
                        setState(() {
                          aerolinea = newValue!;
                        });
                      },
                      items: <String>[
                        'Avianca',
                        'Copa Airlines',
                        'CM Airlines',
                        'Volaris',
                        'United Airlines',
                        'Spirit Airlines',
                        'Delta Airlines'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    TextField(
                      onChanged: (value) => informacionPasajero = value,
                      decoration: const InputDecoration(labelText: 'ID del Pasajero'),
                                            controller: TextEditingController(text: informacionPasajero),
                    ),
                    TextField(
                      onChanged: (value) => origen = value,
                      decoration: const InputDecoration(labelText: 'Origen'),
                      controller: TextEditingController(text: origen),
                    ),
                    TextField(
                      onChanged: (value) => destino = value,
                      decoration: const InputDecoration(labelText: 'Destino'),
                      controller: TextEditingController(text: destino),
                    ),
                    TextField(
                      onChanged: (value) => asiento = value,
                      decoration: const InputDecoration(labelText: 'Asiento'),
                      controller: TextEditingController(text: asiento),
                    ),
                    const SizedBox(height: 20),
                    DropdownButton<String>(
                      value: clase,
                      onChanged: (String? newValue) {
                        setState(() {
                          clase = newValue!;
                        });
                      },
                      items: <String>['Economy', 'Premium Economy', 'Business', 'First Class']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
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
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _firestore.collection('TicketAvion').doc(ticket.id).update({
                      'nombre': nombre,
                      'numeroVuelo': numeroVuelo,
                      'aerolinea': aerolinea,
                      'informacionPasajero': informacionPasajero,
                      'origen': origen,
                      'destino': destino,
                      'asiento': asiento,
                      'clase': clase,
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
      },
    );
  }

  void _deleteTicket(String id) {
    _firestore.collection('TicketAvion').doc(id).delete();
  }

  String _generateRandomFlightNumber() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final letter1 = letters[_random.nextInt(letters.length)];
    final letter2 = letters[_random.nextInt(letters.length)];
    final number = _random.nextInt(9000) + 1000; 
    return '$letter1$letter2$number';
  }

  String _generateRandomSeat() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final letter = letters[_random.nextInt(letters.length)];
    final number = _random.nextInt(50) + 1; 
    return '$number$letter';
  }
}
