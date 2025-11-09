import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/job_offers_repository.dart';

enum StatusUpdateState { initial, loading, success, failure }

class ApplicationStatusManagerViewModel extends StateNotifier<StatusUpdateState> {
  final JobOffersRepository _repository;

  ApplicationStatusManagerViewModel(this._repository) : super(StatusUpdateState.initial);

  Future<void> updateStatus({
    required String applicationId,
    required String newStatus,
  }) async {
    state = StatusUpdateState.loading;
    try {
      await _repository.updateApplicationStatus(
        applicationId: applicationId,
        newStatus: newStatus,
      );
      
      // Una vez actualizado, es buena práctica invalidar el proveedor de la lista de postulantes
      // para forzar la recarga de la lista y mostrar el nuevo estado.
      // ref.invalidate(applicantsByOfferProvider(jobOfferId)); 
      
      state = StatusUpdateState.success;
      
      // Resetear después de un breve período para que el widget pueda reaccionar a la acción
      Future.delayed(const Duration(seconds: 1), () {
        state = StatusUpdateState.initial;
      });

    } catch (e) {
      state = StatusUpdateState.failure;
      // En una aplicación real, deberías almacenar el mensaje de error aquí.
      print('Error al actualizar estado: $e');
    }
  }
}

// Provider para ser usado en el widget (autoDispose para evitar leaks si se usa en un solo lugar)
final applicationStatusManagerProvider = 
    StateNotifierProvider.autoDispose<ApplicationStatusManagerViewModel, StatusUpdateState>((ref) {
  final repository = ref.watch(jobOffersRepositoryProvider);
  return ApplicationStatusManagerViewModel(repository);
});