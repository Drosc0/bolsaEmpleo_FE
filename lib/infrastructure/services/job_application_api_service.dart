import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../dtos/job_application_dto.dart'; // Importa el DTO

class JobApplicationApiService {
  final Dio _dio;

  JobApplicationApiService(this._dio);

  /// Envía la postulación para una oferta de trabajo específica.
  /// Se asume que el ID del aspirante se pasa y el ID de la oferta es el cuerpo.
  Future<JobApplicationDto> applyForJob(String applicantId, String jobOfferId) async {
    try {
      // Endpoint asumido: POST /applicant/:applicantId/applications
      final response = await _dio.post(
        '/applicant/$applicantId/applications',
        data: {
          'jobOfferId': jobOfferId,
        },
      );
      // Retorna el DTO de la postulación creada
      return JobApplicationDto.fromJson(response.data);
    } on DioException catch (e) {
      // Manejo específico de error (ej: ya aplicó)
      if (e.response?.statusCode == 409) { // 409 Conflict (típico para duplicados)
        throw Exception("Ya te has postulado a esta oferta.");
      }
      throw Exception("Fallo en la postulación: ${e.message}");
    }
  }
}

// Provider del servicio (asumiendo que dioProvider existe)
final jobApplicationApiServiceProvider = Provider((ref) {
  // Asegúrate de que tu dioProvider esté disponible
  // final dio = ref.watch(dioProvider); 
  // return JobApplicationApiService(dio);
  throw UnimplementedError('Asegúrate de implementar dioProvider para inicializar JobApplicationApiService.');
});