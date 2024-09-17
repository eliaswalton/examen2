import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:examen2/Models/TicketAvion.dart';

void showTicketDetails(BuildContext context, TicketAvion ticket) {
  String formattedDate = DateFormat('yyyy-MM-dd').format(ticket.fecha);
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Detalles del Ticket'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nombre: ${ticket.nombre}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text('Número de Vuelo: ${ticket.numeroVuelo}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text('Aerolínea: ${ticket.aerolinea}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text('Información del Pasajero: ${ticket.informacionPasajero}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text('Origen: ${ticket.origen}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text('Destino: ${ticket.destino}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text('Asiento: ${ticket.asiento}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text('Clase: ${ticket.clase}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text('Fecha: $formattedDate', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}
