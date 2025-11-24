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

  // A donde he echado el curriculo? Vamos a ver si hay suerte.
  Future<List<Application>> getMyApplications() async {
    final token = await storageService.readToken();

    final response = await apiService.get(
      '/recruitment/applications/me',
      token: token,
    );

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Application.fromJson(json)).toList();
  }

  // Me gusta este trabajo! Me apunto.
  Future<void> applyToJob(int offerId) async {
    final token = await storageService.readToken();

    // Intento 4: El usuario reporta "property jobid should not exist".
    // Esto significa que 'jobId' tampoco es correcto.
    // Probaremos con 'jobOfferId', que es otro nombre común, en algun momento sonara la flauta.

    await apiService.post('/recruitment/applications', {
      'jobOfferId': offerId,
    }, token: token);
  }
}
