import 'dart:convert';
import '../models/company_profile_model.dart';
import '../models/job_offer_model.dart';
import '../../core/services/api_service.dart';
import '../../core/services/secure_storage_service.dart';

class CompanyRepository {
  final ApiService apiService;
  final SecureStorageService storageService;

  CompanyRepository({required this.apiService, required this.storageService});

  /// GET /recruitment/company-profile/me
  /// Obtiene el perfil de la empresa autenticada
  Future<CompanyProfile> getMyCompanyProfile() async {
    final token = await storageService.readToken();

    final response = await apiService.get(
      '/recruitment/company-profile/me',
      token: token,
    );

    final Map<String, dynamic> json = jsonDecode(response.body);
    return CompanyProfile.fromJson(json);
  }

  /// PUT /recruitment/company-profile
  /// Actualiza el perfil de la empresa
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

  /// GET /recruitment/offers (filtered by company)
  /// Obtiene todas las ofertas de la empresa autenticada
  /// Nota: Necesitamos verificar si el backend filtra automáticamente o necesitamos un endpoint específico
  Future<List<JobOffer>> getMyJobOffers() async {
    final token = await storageService.readToken();

    final response = await apiService.get('/recruitment/offers', token: token);

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => JobOffer.fromJson(json)).toList();
  }

  /// POST /recruitment/offers
  /// Crea una nueva oferta de trabajo
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
}
