// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experience_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExperienceItem _$ExperienceItemFromJson(Map<String, dynamic> json) =>
    ExperienceItem(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      company: json['company'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ExperienceItemToJson(ExperienceItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'company': instance.company,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'description': instance.description,
    };
