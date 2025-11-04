import 'package:json_annotation/json_annotation.dart';

part 'skill_item.g.dart';

@JsonSerializable()
class SkillItem {
  //ID requerido para las operaciones DELETE y el seguimiento en el backend
  final int id; 
  final String name;
  final String category; // Ej: 'Técnica', 'Blanda', 'Idioma'
  final String level;    // Ej: 'Avanzado', 'B2', 'Experto'

  SkillItem({
    required this.id,
    required this.name,
    required this.category,
    required this.level,
  });

  factory SkillItem.fromJson(Map<String, dynamic> json) => _$SkillItemFromJson(json);
  
  Map<String, dynamic> toJson() => _$SkillItemToJson(this);
}