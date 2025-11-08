import '../../domain/models/job_application.dart'; 

/// Data Transfer Object para la Postulación.
/// Se utiliza para serializar la respuesta JSON del API.
class JobApplicationDto {
  final String id;
  final String applicantId;
  final String jobOfferId;
  final String status;
  final String appliedAt;

  // Constructor que requiere todos los campos para inmutabilidad
  const JobApplicationDto({
    required this.id,
    required this.applicantId,
    required this.jobOfferId,
    required this.status,
    required this.appliedAt,
  });

  /// Factory para construir el DTO a partir del JSON de la API.
  factory JobApplicationDto.fromJson(Map<String, dynamic> json) {
    return JobApplicationDto(
      id: json['id'] as String,
      applicantId: json['applicantId'] as String,
      jobOfferId: json['jobOfferId'] as String,
      status: json['status'] as String,
      appliedAt: json['appliedAt'] as String,
    );
  }
}

// -----------------------------------------------------------
// Implementación de toDomain() como una EXTENSIÓN (Mappers)
// -----------------------------------------------------------

extension JobApplicationDtoMappers on JobApplicationDto {
  /// Mapea el DTO (Infraestructura) a la entidad de Dominio (Model).
  JobApplication toDomain() {
    return JobApplication(
      id: id,
      applicantId: applicantId,
      jobOfferId: jobOfferId,
      // Usamos el conversor del modelo de Dominio
      status: JobApplication.statusFromString(status), 
      appliedAt: DateTime.parse(appliedAt),
    );
  }
}