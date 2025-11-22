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
}
