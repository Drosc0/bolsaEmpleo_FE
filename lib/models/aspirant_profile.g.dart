// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aspirant_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AspirantProfile _$AspirantProfileFromJson(Map<String, dynamic> json) =>
    AspirantProfile(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      summary: json['summary'] as String?,
      skills: (json['skills'] as List<dynamic>)
          .map((e) => Skill.fromJson(e as Map<String, dynamic>))
          .toList(),
      experience: (json['experience'] as List<dynamic>)
          .map((e) => ExperienceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AspirantProfileToJson(AspirantProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'summary': instance.summary,
      'skills': instance.skills,
      'experience': instance.experience,
    };
