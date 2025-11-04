import 'package:json_annotation/json_annotation.dart';

part 'experience_item.g.dart';

@JsonSerializable()
class ExperienceItem {
  final int id;
  final String title;
  final String company;
  final String? location;
  
  // Usamos DateTime para las fechas, asumiendo que NestJS devuelve ISO 8601 strings
  final DateTime startDate;
  final DateTime? endDate; 
  final String? description;

  ExperienceItem({
    required this.id,
    required this.title,
    required this.company,
    this.location,
    required this.startDate,
    this.endDate,
    this.description,
  });

  factory ExperienceItem.fromJson(Map<String, dynamic> json) => _$ExperienceItemFromJson(json);
  Map<String, dynamic> toJson() => _$ExperienceItemToJson(this);
}