import 'package:bolsa_empleo/config/services/dio_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../dtos/job_application_dto.dart';

class JobApplicationApiService {
  final Dio _dio;

  JobApplicationApiService(this._dio);

  /// Envía la postulación para una oferta de trabajo específica.
  Future<JobApplicationDto> applyForJob(String applicantId, String jobOfferId) async {
    try {
      final response = await _dio.post(
        '/applicant/$applicantId/applications',
        data: {
          'jobOfferId': jobOfferId,
        },
      );
      return JobApplicationDto.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception("Ya te has postulado a esta oferta.");
      }
      throw Exception("Fallo en la postulación: ${e.message}");
    }
  }

  /// Obtiene todas las postulaciones del aspirante (con título y empresa)
  Future<List<JobApplicationDto>> getApplicantApplications(String applicantId) async {
    try {
      final response = await _dio.get('/applicant/$applicantId/applications');

      final data = response.data as List;
      return data.map((json) => JobApplicationDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception("Error al obtener postulaciones: ${e.message}");
    }
  }
}

// --------------------------------------------------------------------------
// Provider del servicio (requiere dioProvider definido en tu proyecto)
// --------------------------------------------------------------------------

final jobApplicationApiServiceProvider = Provider<JobApplicationApiService>((ref) {
  final dio = ref.watch(dioProvider); // ← Asegúrate de tener este provider en core/di/providers.dart
  return JobApplicationApiService(dio);
});
