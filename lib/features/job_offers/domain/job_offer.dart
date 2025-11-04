// Clase modelo para una Oferta de Empleo
class JobOffer {
  final String id;
  final String title;
  final String company;
  final String location;
  final int minSalary;
  final int maxSalary;
  final String description;

  JobOffer({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.minSalary,
    required this.maxSalary,
    required this.description,
  });

  // Método de fábrica para crear una JobOffer desde un JSON (futura integración con NestJS)
  factory JobOffer.fromJson(Map<String, dynamic> json) {
    return JobOffer(
      id: json['id'] as String,
      title: json['title'] as String,
      company: json['company'] as String,
      location: json['location'] as String,
      minSalary: json['minSalary'] as int,
      maxSalary: json['maxSalary'] as int,
      description: json['description'] as String,
    );
  }
}