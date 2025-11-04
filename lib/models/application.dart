import 'package:json_annotation/json_annotation.dart';
import 'job_offer.dart';
import 'aspirant_profile.dart'; 

part 'application.g.dart';

enum ApplicationStatus {
  @JsonValue('PENDIENTE') // Cambiado a mayúsculas para ser consistente con backends típicos
  pending,
  @JsonValue('REVISADA')
  reviewed,
  @JsonValue('ENTREVISTA')
  interview,
  @JsonValue('ACEPTADA')
  accepted,
  @JsonValue('RECHAZADA')
  rejected,
  @JsonValue('RETIRADA')
  withdrawn,
}

extension ApplicationStatusExtension on ApplicationStatus {
  // Este método devuelve el String que el backend espera al enviar datos.
  String toJson() {
    // Usamos el valor decorado por @JsonValue (ej: 'PENDIENTE')
    return _$ApplicationStatusEnumMap[this]!;
  }
}

@JsonSerializable(explicitToJson: true)
class Application {
  final int id;
  final ApplicationStatus status;
  final DateTime appliedAt;
  final String? comments;

  // Detalles de la oferta a la que se postuló
  final JobOffer jobOffer; 
  
  // Necesitas incluir el perfil del aspirante para que la Empresa lo vea
  final AspirantProfile? aspirantProfile; 

  Application({
    required this.id,
    required this.status,
    required this.appliedAt,
    this.comments,
    required this.jobOffer,
    this.aspirantProfile, // Se requiere si se usa en la Empresa
  });

  factory Application.fromJson(Map<String, dynamic> json) => _$ApplicationFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicationToJson(this);
}

const _$ApplicationStatusEnumMap = {
  ApplicationStatus.pending: 'PENDIENTE',
  ApplicationStatus.reviewed: 'REVISADA',
  ApplicationStatus.interview: 'ENTREVISTA',
  ApplicationStatus.accepted: 'ACEPTADA',
  ApplicationStatus.rejected: 'RECHAZADA',
  ApplicationStatus.withdrawn: 'RETIRADA',
};