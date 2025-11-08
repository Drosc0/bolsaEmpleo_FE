import 'package:bolsa_empleo/infrastructure/dtos/job_application_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/job_application.dart'; 
import '../../infrastructure/services/job_application_api_service.dart';

class JobApplicationRepository {
  final JobApplicationApiService _apiService;

  JobApplicationRepository(this._apiService);

  /// Lógica de postulación: toma IDs y retorna el modelo de dominio.
  Future<JobApplication> applyForJob(String applicantId, String jobOfferId) async {
    try {
      final dto = await _apiService.applyForJob(applicantId, jobOfferId);
      // Convierte el DTO de respuesta a un Modelo de Dominio
      return dto.toDomain(); 
    } catch (e) {
      // Re-lanza errores del API Service
      throw Exception(e.toString()); 
    }
  }
}

// Provider del repositorio
final jobApplicationRepositoryProvider = Provider((ref) {
  final apiService = ref.watch(jobApplicationApiServiceProvider);
  // ignore: dead_code
  return JobApplicationRepository(apiService);
});