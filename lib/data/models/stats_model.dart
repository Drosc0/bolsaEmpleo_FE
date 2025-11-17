class AppStats {
  final int totalUsers;
  final int aspirants;
  final int companies;

  AppStats({
    required this.totalUsers,
    required this.aspirants,
    required this.companies,
  });
  
  // Asumimos un endpoint para /stats que devuelve estas claves
  factory AppStats.fromJson(Map<String, dynamic> json) {
    return AppStats(
      totalUsers: json['totalUsers'] as int,
      aspirants: json['aspirants'] as int,
      companies: json['companies'] as int,
    );
  }
}