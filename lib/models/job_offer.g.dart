// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobOffer _$JobOfferFromJson(Map<String, dynamic> json) => JobOffer(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  location: json['location'] as String,
  salary: (json['salary'] as num).toDouble(),
  postedAt: DateTime.parse(json['postedAt'] as String),
  companyName: json['companyName'] as String,
  requirements: (json['requirements'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  applicationsCount: (json['applicationsCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$JobOfferToJson(JobOffer instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'location': instance.location,
  'salary': instance.salary,
  'postedAt': instance.postedAt.toIso8601String(),
  'companyName': instance.companyName,
  'requirements': instance.requirements,
  'applicationsCount': instance.applicationsCount,
};
