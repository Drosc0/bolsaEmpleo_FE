import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bolsa_empleo/domain/repositories/job_application_repository.dart'; // Tu repositorio
import 'job_apply_state.dart'; // El estado que acabamos de crear

class JobApplyViewModel extends StateNotifier<JobApplyState> {
  final JobApplicationRepository _repository;
  // El ID del aspirante se debe inyectar (ej. desde un proveedor de autenticación)
  final String _applicantId; 

  JobApplyViewModel(this._repository, this._applicantId) : super(const JobApplyState());

  /// Ejecuta la postulación a una oferta de trabajo.
  Future<void> applyForJob(String jobOfferId) async {
    // 1. Iniciar el estado de carga
    state = state.copyWith(status: ApplicationActionStatus.submitting, errorMessage: null);

    try {
      // 2. Llamar al repositorio
      final newApplication = await _repository.applyForJob(_applicantId, jobOfferId);

      // 3. Postulación exitosa
      state = state.copyWith(
        status: ApplicationActionStatus.success,
        application: newApplication,
      );

    } catch (e) {
      // 4. Postulación fallida (manejo de errores del repositorio/API)
      state = state.copyWith(
        status: ApplicationActionStatus.failure,
        errorMessage: e.toString().contains('Ya te has postulado') 
                      ? 'Ya aplicaste a esta oferta.' 
                      : 'Error al procesar la postulación: ${e.toString()}',
      );
    }
  }
  
  /// Reinicia el estado después de una acción (útil para reintentos o cerrar el modal)
  void resetState() {
    state = const JobApplyState();
  }
}

// ----------------------------------------------------------------
// Provider: Permite que el ViewModel sea inyectado en la UI
// ----------------------------------------------------------------

// Usaremos AutoDispose para que se limpie cuando el widget ya no lo necesite (ej. al cerrar la pantalla de detalles)
final jobApplyViewModelProvider = StateNotifierProvider.autoDispose<JobApplyViewModel, JobApplyState>((ref) {
  final repository = ref.watch(jobApplicationRepositoryProvider);
  
  //  Reemplazar con la lógica real para obtener el ID del usuario autenticado
  const applicantId = 'applicant-user-id-placeholder'; 

  return JobApplyViewModel(repository, applicantId);
});