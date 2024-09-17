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
      'fecha': fecha.toIso8601String(),
    };
  }

  factory TicketAvion.fromMap(Map<String, dynamic> map, String documentId) {
    return TicketAvion(
      id: documentId,
      nombre: map['nombre'],
      destino: map['destino'],
      fecha: DateTime.parse(map['fecha']),
    );
  }
}
