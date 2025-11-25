class JobOffer {
  final int id;
  final String title;
  final String companyName;
  final int? companyId;
  final String location;
  final String salaryRange;
  final String description;

  JobOffer({
    required this.id,
    required this.title,
    required this.companyName,
    this.companyId,
    required this.location,
    required this.salaryRange,
    required this.description,
  });

  // Método de fábrica para mapear de JSON (backend)
  factory JobOffer.fromJson(Map<String, dynamic> json) {
    
    return JobOffer(
      id: json['id'] as int,
      title: json['title'] as String,
      companyName: json['company']?['name'] as String? ?? 'N/A',
      companyId: json['company']?['id'] as int?,
      location: json['location'] as String,
      salaryRange: json['salaryRange'] as String,
      description: json['description'] as String? ?? 'Sin descripción',
    );
  }
}
