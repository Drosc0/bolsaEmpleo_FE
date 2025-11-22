class Profile {
  final int id;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? linkedinUrl;
  final String? portfolioUrl;
  final String? email;

  Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.linkedinUrl,
    this.portfolioUrl,
    this.email,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String?,
      linkedinUrl: json['linkedinUrl'] as String?,
      portfolioUrl: json['portfolioUrl'] as String?,
      email: json['email'] as String?,
    );
  }

  String get fullName => '$firstName $lastName';
}
