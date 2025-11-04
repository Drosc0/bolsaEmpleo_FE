import 'package:json_annotation/json_annotation.dart';
// import 'skill.dart'; 
import 'skill_item.dart'; 
import 'experience_item.dart';

part 'aspirant_profile.g.dart';

@JsonSerializable(explicitToJson: true) // Sugerencia: Añadir explicitToJson
class AspirantProfile {
final int id;
final String name;
final String email;
final String? phone;
final String? summary;

// Usar SkillItem
final List<SkillItem> skills;
final List<ExperienceItem> experience;

AspirantProfile({
required this.id,
required this.name,
required this.email,
this.phone,
this.summary,
required this.skills,
required this.experience,
});

factory AspirantProfile.fromJson(Map<String, dynamic> json) => _$AspirantProfileFromJson(json);
 Map<String, dynamic> toJson() => _$AspirantProfileToJson(this);
 
 AspirantProfile copyWith({
  int? id,
  String? name,
  String? email,
  String? phone,
  String? summary,
  List<SkillItem>? skills,
  List<ExperienceItem>? experience,
  }) {
 return AspirantProfile(
 id: id ?? this.id,
 name: name ?? this.name,
 email: email ?? this.email,
 phone: phone ?? this.phone,
 summary: summary ?? this.summary,
skills: skills ?? this.skills,
experience: experience ?? this.experience,
 );
 }
}