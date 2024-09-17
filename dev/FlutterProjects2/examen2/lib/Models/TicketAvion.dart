import 'package:cloud_firestore/cloud_firestore.dart';

class TicketAvion {
  final String id;
  final String nombre;
  final String numeroVuelo;
  final String aerolinea;
  final String informacionPasajero;
  final String origen;
  final String destino;
  final String asiento;
  final String clase;
  final DateTime fecha;

  TicketAvion({
    required this.id,
    required this.nombre,
    required this.numeroVuelo,
    required this.aerolinea,
    required this.informacionPasajero,
    required this.origen,
    required this.destino,
    required this.asiento,
    required this.clase,
    required this.fecha,
  });

  factory TicketAvion.fromMap(Map<String, dynamic> data, String documentId) {
    return TicketAvion(
      id: documentId,
      nombre: data['nombre'] ?? '',
      numeroVuelo: data['numeroVuelo'] ?? '',
      aerolinea: data['aerolinea'] ?? '',
      informacionPasajero: data['informacionPasajero'] ?? '',
      origen: data['origen'] ?? '',
      destino: data['destino'] ?? '',
      asiento: data['asiento'] ?? '',
      clase: data['clase'] ?? '',
      fecha: (data['fecha'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'numeroVuelo': numeroVuelo,
      'aerolinea': aerolinea,
      'informacionPasajero': informacionPasajero,
      'origen': origen,
      'destino': destino,
      'asiento': asiento,
      'clase': clase,
      'fecha': fecha,
    };
  }
}
