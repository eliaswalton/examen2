import 'package:cloud_firestore/cloud_firestore.dart';

class TicketAvion {
  String id;
  String nombre;
  String destino;
  DateTime fecha;

  TicketAvion({required this.id, required this.nombre, required this.destino, required this.fecha});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'destino': destino,
      'fecha': Timestamp.fromDate(fecha),
    };
  }

  factory TicketAvion.fromMap(Map<String, dynamic> map, String documentId) {
    return TicketAvion(
      id: documentId,
      nombre: map['nombre'],
      destino: map['destino'],
      fecha: (map['fecha'] as Timestamp).toDate(),



    );
  }
}
