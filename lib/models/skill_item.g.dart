// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkillItem _$SkillItemFromJson(Map<String, dynamic> json) => SkillItem(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  category: json['category'] as String,
  level: json['level'] as String,
);

Map<String, dynamic> _$SkillItemToJson(SkillItem instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'category': instance.category,
  'level': instance.level,
};
