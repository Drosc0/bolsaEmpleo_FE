// Clase modelo para una Oferta de Empleo
class JobOffer {
  final String id;
  final String title;
  final String company;
  final String location;
  final int minSalary;
  final int maxSalary;
  final String description;
  final String contractType; 
  final DateTime postedDate;

  JobOffer({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.minSalary,
    required this.maxSalary,
    required this.description,
    required this.contractType, 
    required this.postedDate,
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
      
      // Asignar valores del JSON
      contractType: json['contractType'] as String, 
      // Convertir el String del JSON a un objeto DateTime de Dart
      postedDate: DateTime.parse(json['postedDate'] as String), 
    );
  }
}