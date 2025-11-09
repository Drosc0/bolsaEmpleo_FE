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