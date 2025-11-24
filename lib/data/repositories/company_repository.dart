import 'dart:convert';
import '../models/company_profile_model.dart';
import '../models/job_offer_model.dart';
import '../models/application_model.dart';
import '../../core/services/api_service.dart';
import '../../core/services/secure_storage_service.dart';

class CompanyRepository {
  final ApiService apiService;
  final SecureStorageService storageService;

  CompanyRepository({required this.apiService, required this.storageService});

  // Aqui pido los datos de mi empresa, para saber quien soy.
  Future<CompanyProfile> getMyCompanyProfile() async {
    final token = await storageService.readToken();

    final response = await apiService.get(
      '/recruitment/company-profile/me',
      token: token,
    );

    final Map<String, dynamic> json = jsonDecode(response.body);
    return CompanyProfile.fromJson(json);
  }

  // Aqui mando los cambios del perfil al servidor. Ojala les guste.
  Future<CompanyProfile> updateCompanyProfile(
    Map<String, dynamic> profileData,
  ) async {
    final token = await storageService.readToken();

    final response = await apiService.put(
      '/recruitment/company-profile',
      profileData,
      token: token,
    );

    final Map<String, dynamic> json = jsonDecode(response.body);
    return CompanyProfile.fromJson(json);
  }

  // Traeme todas las ofertas que he creado, que quiero verlas.
  Future<List<JobOffer>> getMyJobOffers() async {
    final token = await storageService.readToken();

    final response = await apiService.get('/recruitment/offers', token: token);

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => JobOffer.fromJson(json)).toList();
  }

  // Crear una oferta nueva. A ver si alguien pica.
  Future<JobOffer> createJobOffer(Map<String, dynamic> offerData) async {
    final token = await storageService.readToken();

    final response = await apiService.post(
      '/recruitment/offers',
      offerData,
      token: token,
    );

    final Map<String, dynamic> json = jsonDecode(response.body);
    return JobOffer.fromJson(json);
  }

  // Quien se ha apuntado a esta oferta? Vamos a cotillear.
  Future<List<Application>> getApplicationsForOffer(int offerId) async {
    final token = await storageService.readToken();

    final response = await apiService.get(
      '/recruitment/offers/$offerId/applications',
      token: token,
    );

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Application.fromJson(json)).toList();
  }

  // Cambiamos el estado del candidato. Contratado o a su casa.
  Future<void> updateApplicationStatus(int applicationId, String status) async {
    final token = await storageService.readToken();

    await apiService.put('/recruitment/applications/$applicationId/status', {
      'status': status,
    }, token: token);
  }

  // Si me he equivocado en la oferta, aqui la arreglo.
  Future<JobOffer> updateJobOffer(
    int offerId,
    Map<String, dynamic> offerData,
  ) async {
    final token = await storageService.readToken();

    final response = await apiService.put(
      '/recruitment/offers/$offerId',
      offerData,
      token: token,
    );

    final Map<String, dynamic> json = jsonDecode(response.body);
    return JobOffer.fromJson(json);
  }

  // Borrar la oferta. Si no la quiero, fuera.
  Future<void> deleteJobOffer(int offerId) async {
    final token = await storageService.readToken();

    await apiService.delete('/recruitment/offers/$offerId', token: token);
  }
}
