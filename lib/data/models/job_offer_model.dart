class JobOffer {
  final int id;
  final String title;
  final String companyName;
  final String location;
  final String salaryRange;

  JobOffer({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    required this.salaryRange,
  });

  // Método de fábrica para mapear de JSON (backend)
  factory JobOffer.fromJson(Map<String, dynamic> json) {
    return JobOffer(
      id: json['id'] as int,
      title: json['title'] as String,
      companyName: json['company']?['companyName'] as String? ?? 'N/A',
      location: json['location'] as String,
      salaryRange: json['salaryRange'] as String,
    );
  }
}

// En: lib/data/models/stats_model.dart (Simulación de un endpoint de estadísticas)
class AppStats {
  final int totalUsers;
  final int aspirants;
  final int companies;

  AppStats({
    required this.totalUsers,
    required this.aspirants,
    required this.companies,
  });
  
  // Asumimos un endpoint para /stats
  factory AppStats.fromJson(Map<String, dynamic> json) {
    return AppStats(
      totalUsers: json['totalUsers'] as int,
      aspirants: json['aspirants'] as int,
      companies: json['companies'] as int,
    );
  }
}