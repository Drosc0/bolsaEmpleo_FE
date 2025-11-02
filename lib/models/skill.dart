import 'package:json_annotation/json_annotation.dart';

part 'skill.g.dart';

// El nivel se mapea directamente al número 1-5 que usaste en el DTO
@JsonSerializable()
class Skill {
  final int id;
  final String name;
  final String category;
  final int level; // 1 to 5

  Skill({
    required this.id,
    required this.name,
    required this.category,
    required this.level,
  });

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);
  Map<String, dynamic> toJson() => _$SkillToJson(this);
}