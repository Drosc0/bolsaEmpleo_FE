import 'dart:convert';
import '../models/application_model.dart';
import '../../core/services/api_service.dart';
import '../../core/services/secure_storage_service.dart';

class ApplicationsRepository {
  final ApiService apiService;
  final SecureStorageService storageService;

  ApplicationsRepository({
    required this.apiService,
    required this.storageService,
  });

  /// GET /recruitment/applications/me
  /// Obtiene todas las candidaturas del aspirante autenticado
  Future<List<Application>> getMyApplications() async {
    final token = await storageService.readToken();

    final response = await apiService.get(
      '/recruitment/applications/me',
      token: token,
    );

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Application.fromJson(json)).toList();
  }

  /// POST /recruitment/applications
  /// Postula a una oferta de trabajo
  Future<void> applyToJob(int offerId) async {
    final token = await storageService.readToken();

    // Intento 3: Volver a POST /recruitment/applications pero con 'jobId' en el body.
    // El error original fue "property offerId should not exist", lo que sugiere que el DTO
    // no tiene 'offerId'. Es muy probable que se llame 'jobId' o 'jobOfferId'.
    // Probaremos con 'jobId' que es lo más estándar.

    await apiService.post('/recruitment/applications', {
      'jobId': offerId,
    }, token: token);
  }
}
