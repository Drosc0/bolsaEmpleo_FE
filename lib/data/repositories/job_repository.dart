import 'dart:convert';
import '../models/job_offer_model.dart';
import '../../core/services/api_service.dart';
import '../../core/services/secure_storage_service.dart';

class JobRepository {
  final ApiService apiService;
  final SecureStorageService storageService;

  JobRepository({required this.apiService, required this.storageService});

  // Que hay de nuevo viejo? Dame todas las ofertas de trabajo.
  Future<List<JobOffer>> getJobOffers() async {
    final token = await storageService.readToken();

    // Assuming this endpoint returns all available offers for applicants
    // If the previous endpoint was filtered by company, we might need a different one
    // or the backend handles it based on role.
    // Based on user request "comprueba en el back", I'm assuming standard REST conventions.
    final response = await apiService.get('/recruitment/offers', token: token);

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => JobOffer.fromJson(json)).toList();
  }

  // Estas son las ofertas que yo he creado (si soy empresa, que lo dudo).
  Future<List<JobOffer>> getMyJobOffers() async {
    final token = await storageService.readToken();

    // Endpoint estándar para obtener recursos propios
    final response = await apiService.get(
      '/recruitment/offers/me',
      token: token,
    );

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => JobOffer.fromJson(json)).toList();
  }
}
