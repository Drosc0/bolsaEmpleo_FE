class JobOffer {
  final int id;
  final String title;
  final String companyName;
  final String location;
  final String salaryRange;
  final String description;

  JobOffer({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    required this.salaryRange,
    required this.description,
  });

  // Método de fábrica para mapear de JSON (backend)
  factory JobOffer.fromJson(Map<String, dynamic> json) {
    // He ajustado el manejo de 'companyName' para el backend NestJS/Supabase
    // que normalmente devuelve una relación anidada.
    return JobOffer(
      id: json['id'] as int,
      title: json['title'] as String,
      companyName: json['company']?['name'] as String? ?? 'N/A',
      location: json['location'] as String,
      salaryRange: json['salaryRange'] as String,
      description: json['description'] as String? ?? 'Sin descripción',
    );
  }
}
