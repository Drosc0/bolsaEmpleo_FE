import 'package:bolsa_empleo/infrastructure/dtos/job_application_dto.dart';
import 'package:bolsa_empleo/infrastructure/services/job_application_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/job_application.dart';

/// Repositorio de postulaciones (Clean Architecture: Infrastructure → Domain)
class JobApplicationRepository {
  final JobApplicationApiService _apiService;

  JobApplicationRepository(this._apiService);

  /// Postularse a una oferta
  Future<JobApplication> applyForJob({
    required String applicantId,
    required String jobOfferId,
  }) async {
    try {
      final dto = await _apiService.applyForJob(applicantId, jobOfferId);
      return dto.toDomain();
    } catch (e) {
      throw Exception('Error al postularse: $e');
    }
  }

  /// Obtener todas las postulaciones del aspirante (con título y empresa)
  Future<List<JobApplication>> getApplicantApplications(String applicantId) async {
    try {
      // 1. Obtener DTOs desde el API
      final List<JobApplicationDto> dtos = await _apiService.getApplicantApplications(applicantId);

      // 2. Convertir a modelos de dominio
      return dtos.map((dto) => dto.toDomain()).toList();

    } catch (e) {
      throw Exception('Error al cargar las postulaciones: $e');
    }
  }
}

// --------------------------------------------------------------------------
// PROVIDER
// --------------------------------------------------------------------------

final jobApplicationRepositoryProvider = Provider<JobApplicationRepository>((ref) {
  ref.watch(jobApplicationApiServiceProvider);
});