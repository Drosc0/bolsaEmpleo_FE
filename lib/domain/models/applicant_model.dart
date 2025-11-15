class ApplicantModel {
  final String id;
  final String name;
  final String email;
  final String status; // Ej: 'submitted', 'reviewed', 'interview', 'rejected'
  final DateTime appliedAt;
  
  // Puedes añadir campos adicionales como enlace al CV, teléfono, etc.
  // final String? cvUrl;

  ApplicantModel({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.appliedAt,
    // this.cvUrl,
  });

  //CONSTRUCTOR DE FÁBRICA FROM JSON
  factory ApplicantModel.fromJson(Map<String, dynamic> json) {
    // Asegúrate de que las claves (id, name, etc.) coincidan con las que devuelve tu API.
    return ApplicantModel(
      // Convierte a String si es necesario y asegura que el campo existe.
      id: json['id'].toString(), 
      name: json['name'] as String,
      email: json['email'] as String,
      status: json['status'] as String,
      // Convierte la cadena ISO 8601 (del backend) a un objeto DateTime de Dart.
      appliedAt: DateTime.parse(json['appliedAt'] as String), 
      // Si añades cvUrl: cvUrl: json['cvUrl'] as String?,
    );
  }

  // Método opcional para crear una copia inmutable con el estado actualizado
  ApplicantModel copyWith({
    String? status,
    String? email,
  }) {
    return ApplicantModel(
      id: id,
      name: name,
      email: email ?? this.email,
      status: status ?? this.status,
      appliedAt: appliedAt,
    );
  }
}