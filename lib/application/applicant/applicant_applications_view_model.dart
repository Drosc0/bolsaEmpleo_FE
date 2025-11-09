import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/job_application.dart';
import '../../domain/repositories/job_application_repository.dart';

// Usaremos AsyncNotifier para manejar el estado AsyncValue<List<JobApplication>>
class ApplicantApplicationsViewModel extends AsyncNotifier<List<JobApplication>> {
  
  // Método obligatorio para inicializar el estado
  @override
  Future<List<JobApplication>> build() async {
    final repository = ref.watch(jobApplicationRepositoryProvider);
    
    // Obtener ID real del usuario autenticado
    const applicantId = 'applicant-user-id-placeholder'; 
    
    return repository.getApplicantApplications(applicantId);
  }

  /// Refresca la lista de postulaciones (para Pull-to-Refresh)
  Future<void> refreshApplications() async {
    state = const AsyncValue.loading();
    await build();
  }
}

final applicantApplicationsProvider = 
    AsyncNotifierProvider<ApplicantApplicationsViewModel, List<JobApplication>>(() {
  return ApplicantApplicationsViewModel();
});