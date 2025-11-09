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

  /// Obtiene todas las postulaciones enviadas por un aspirante.
  Future<List<JobApplication>> getApplicantApplications(String applicantId) async {
    try {
      //Implementar la llamada real a la API, ej: GET /applicant/:applicantId/applications
      
      // *** SIMULACIÓN TEMPORAL (Reemplazar con lógica API real) ***
      await Future.delayed(const Duration(milliseconds: 700));

      final List<Map<String, dynamic>> fakeData = [
        {'id': 'a1', 'jobOfferId': '1', 'status': 'submitted', 'appliedAt': DateTime.now().subtract(const Duration(days: 10)).toIso8601String()},
        {'id': 'a2', 'jobOfferId': '2', 'status': 'interview', 'appliedAt': DateTime.now().subtract(const Duration(days: 7)).toIso8601String()},
        {'id': 'a3', 'jobOfferId': '3', 'status': 'rejected', 'appliedAt': DateTime.now().subtract(const Duration(days: 5)).toIso8601String()},
        // En una app real, la API devolvería también los detalles básicos del JobOffer asociado.
      ];

      return fakeData.map((json) => JobApplication(
        id: json['id']!,
        applicantId: applicantId,
        jobOfferId: json['jobOfferId']!,
        status: JobApplication.statusFromString(json['status']!),
        appliedAt: DateTime.parse(json['appliedAt']!),
      )).toList();

    } catch (e) {
      throw Exception('Error al cargar las postulaciones: $e');
    }
  }
}


// Provider del repositorio
final jobApplicationRepositoryProvider = Provider((ref) {
  final apiService = ref.watch(jobApplicationApiServiceProvider);
  // ignore: dead_code
  return JobApplicationRepository(apiService);
});