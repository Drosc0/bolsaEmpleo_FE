// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Application _$ApplicationFromJson(Map<String, dynamic> json) => Application(
  id: (json['id'] as num).toInt(),
  status: $enumDecode(_$ApplicationStatusEnumMap, json['status']),
  appliedAt: DateTime.parse(json['appliedAt'] as String),
  comments: json['comments'] as String?,
  jobOffer: JobOffer.fromJson(json['jobOffer'] as Map<String, dynamic>),
  aspirantProfile: json['aspirantProfile'] == null
      ? null
      : AspirantProfile.fromJson(
          json['aspirantProfile'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$ApplicationToJson(Application instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$ApplicationStatusEnumMap[instance.status]!,
      'appliedAt': instance.appliedAt.toIso8601String(),
      'comments': instance.comments,
      'jobOffer': instance.jobOffer.toJson(),
      'aspirantProfile': instance.aspirantProfile?.toJson(),
    };

