import 'skill_model.dart';
import 'experience_model.dart';

class Profile {
  final int id;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? linkedinUrl;
  final String? portfolioUrl;
  final String? email;
  final List<Skill> skills;
  final List<Experience> experience;

  Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.linkedinUrl,
    this.portfolioUrl,
    this.email,
    this.skills = const [],
    this.experience = const [],
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as int,
      firstName: json['firstName'] as String? ?? 'Usuario',
      lastName: json['lastName'] as String? ?? '',
      phone: json['phone'] as String?,
      linkedinUrl: json['linkedinUrl'] as String?,
      portfolioUrl: json['portfolioUrl'] as String?,
      email: json['email'] as String?,
      skills:
          (json['skills'] as List<dynamic>?)
              ?.map((e) => Skill.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      experience:
          (json['experience'] as List<dynamic>?)
              ?.map((e) => Experience.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  String get fullName => '$firstName $lastName';
}
