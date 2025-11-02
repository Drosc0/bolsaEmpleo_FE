import 'package:json_annotation/json_annotation.dart';
import 'skill.dart';
import 'experience_item.dart';

part 'aspirant_profile.g.dart';

@JsonSerializable()
class AspirantProfile {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? summary;

  final List<Skill> skills;
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
}