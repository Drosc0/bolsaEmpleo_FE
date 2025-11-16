
import '../../domain/models/job_application.dart';

/// Data Transfer Object para la Postulación.
/// Se utiliza para serializar la respuesta JSON del API.
class JobApplicationDto {
  final String id;
  final String applicantId;
  final String jobOfferId;
  final String jobTitle;      
  final String companyName;   
  final String status;
  final String appliedAt;

  // Constructor que requiere todos los campos para inmutabilidad
  const JobApplicationDto({
    required this.id,
    required this.applicantId,
    required this.jobOfferId,
    required this.jobTitle,
    required this.companyName,
    required this.status,
    required this.appliedAt,
  });

  /// Factory para construir el DTO a partir del JSON de la API.
  factory JobApplicationDto.fromJson(Map<String, dynamic> json) {
    return JobApplicationDto(
      id: json['id'] as String,
      applicantId: json['applicant_id'] as String,
      jobOfferId: json['job_offer_id'] as String,
      jobTitle: json['job_offer']['title'] as String? ?? 'Oferta sin título',
      companyName: json['job_offer']['company']['name'] as String? ?? 'Empresa desconocida',
      status: json['status'] as String,
      appliedAt: json['applied_at'] as String,
    );
  }

  /// toJson (opcional, útil para pruebas o envío)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'applicant_id': applicantId,
      'job_offer_id': jobOfferId,
      'job_title': jobTitle,
      'company_name': companyName,
      'status': status,
      'applied_at': appliedAt,
    };
  }
}

// -----------------------------------------------------------
// EXTENSIÓN: Mapea el DTO a la entidad de Dominio (Model).
// -----------------------------------------------------------
extension JobApplicationDtoMappers on JobApplicationDto {
  JobApplication toDomain() {
    return JobApplication(
      id: id,
      applicantId: applicantId,
      jobOfferId: jobOfferId,
      jobTitle: jobTitle,
      companyName: companyName,
      status: JobApplication.statusFromString(status),
      appliedAt: DateTime.parse(appliedAt),
    );
  }
}
