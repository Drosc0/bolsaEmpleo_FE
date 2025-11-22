class CompanyProfile {
  final int id;
  final String companyName;
  final String? description;
  final String? website;
  final String? location;
  final String? email;

  CompanyProfile({
    required this.id,
    required this.companyName,
    this.description,
    this.website,
    this.location,
    this.email,
  });

  factory CompanyProfile.fromJson(Map<String, dynamic> json) {
    return CompanyProfile(
      id: json['id'] as int,
      companyName: json['companyName'] as String,
      description: json['description'] as String?,
      website: json['website'] as String?,
      location: json['location'] as String?,
      email: json['email'] as String?,
    );
  }
}
