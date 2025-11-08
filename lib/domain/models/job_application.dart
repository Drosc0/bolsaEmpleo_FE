// -------------------------------------------------------------------
// 1. Enum para el Estado de la Postulación
// -------------------------------------------------------------------

/// Representa el estado actual del proceso de postulación.
enum ApplicationStatus {
  /// Postulación enviada por el aspirante.
  submitted, 
  /// La empresa ha revisado o marcado la postulación.
  reviewed,  
  /// El aspirante ha sido preseleccionado o llamado a entrevista.
  interview, 
  /// La postulación ha sido rechazada por la empresa.
  rejected,  
  /// Estado desconocido o no inicializado (útil para la UI)
  unknown,
}

// -------------------------------------------------------------------
// 2. Modelo de Postulación a Empleo (JobApplication)
// -------------------------------------------------------------------

/// Representa una postulación única de un aspirante a una oferta.
class JobApplication {
  final String id;
  final String applicantId;
  final String jobOfferId;
  final ApplicationStatus status;
  final DateTime appliedAt;

  JobApplication({
    required this.id,
    required this.applicantId,
    required this.jobOfferId,
    required this.status,
    required this.appliedAt,
  });
  
  // Método de utilidad para mapear desde String a Enum (usado en el Repositorio)
  static ApplicationStatus statusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return ApplicationStatus.submitted;
      case 'reviewed':
        return ApplicationStatus.reviewed;
      case 'interview':
        return ApplicationStatus.interview;
      case 'rejected':
        return ApplicationStatus.rejected;
      default:
        return ApplicationStatus.unknown;
    }
  }
}