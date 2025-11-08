import '../../domain/models/job_application.dart';

// -------------------------------------------------------------------
// 1. Enum para el Estado de la Postulación
// -------------------------------------------------------------------

/// Enum que representa el progreso de la acción de postulación.
enum ApplicationActionStatus { 
  /// Estado inicial, no se ha intentado la postulación.
  initial, 
  /// La postulación está en curso.
  submitting, 
  /// Postulación exitosa.
  success, 
  /// La postulación falló.
  failure 
}

// -------------------------------------------------------------------
// 2. Clase Simple Inmutable para el Estado
// -------------------------------------------------------------------

class JobApplyState {
  final ApplicationActionStatus status;
  final String? errorMessage;
  final JobApplication? application; // El resultado de la postulación exitosa

  const JobApplyState({
    this.status = ApplicationActionStatus.initial,
    this.errorMessage,
    this.application,
  });

  /// Método de copia manual para mantener la inmutabilidad (reemplaza copyWith de Freezed)
  JobApplyState copyWith({
    ApplicationActionStatus? status,
    String? errorMessage,
    JobApplication? application,
  }) {
    return JobApplyState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      application: application,
    );
  }
}