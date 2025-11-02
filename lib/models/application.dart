import 'package:json_annotation/json_annotation.dart';
import 'job_offer.dart';

part 'application.g.dart';

enum ApplicationStatus {
  @JsonValue('Pendiente')
  pending,
  @JsonValue('Revisada')
  reviewed,
  @JsonValue('Aceptada')
  accepted,
  @JsonValue('Rechazada')
  rejected,
  @JsonValue('Retirada')
  withdrawn,
}

@JsonSerializable()
class Application {
  final int id;
  final ApplicationStatus status;
  final DateTime appliedAt;
  final String? comments;

  // Detalles de la oferta a la que se postuló
  final JobOffer jobOffer; 

  Application({
    required this.id,
    required this.status,
    required this.appliedAt,
    this.comments,
    required this.jobOffer,
  });

  factory Application.fromJson(Map<String, dynamic> json) => _$ApplicationFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicationToJson(this);
}