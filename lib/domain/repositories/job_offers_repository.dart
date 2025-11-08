import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/services/job_offers_api_service.dart'; // Importa el API Service
// Importa los Modelos de Dominio que usan tus ViewModels (definidos en los ViewModels)
import '../../application/applicant/user_home_view_model.dart' as applicant_models;
import '../../application/company/company_home_view_model.dart' as company_models;


// --------------------------------------------------------------------------
// 1. Repositorio (Clase)
// --------------------------------------------------------------------------

class JobOffersRepository {
  final JobOffersApiService _apiService;

  JobOffersRepository(this._apiService);

  // Método para el Aspirante
  Future<List<applicant_models.JobOffer>> fetchRecommendedOffers(String userId) async {
    try {
      final dtos = await _apiService.getRecommendedOffers(userId);
      
      // Mapear DTOs de Infraestructura a Modelos de Dominio (ViewModel)
      return dtos.map((dto) => applicant_models.JobOffer(
        dto.id,
        dto.title,
        dto.company,
        dto.location,
      )).toList();
      
    } catch (e) {
      // Manejo de errores centralizado, puedes lanzar tu propia excepción de dominio aquí
      throw Exception('Error al obtener ofertas recomendadas: $e');
    }
  }

  // Método para la Empresa
  Future<List<company_models.PostedJobOffer>> fetchPostedOffers(String companyId) async {
    try {
      final dtos = await _apiService.getPostedOffers(companyId);
      
      // Mapear DTOs de Infraestructura a Modelos de Dominio (ViewModel)
      return dtos.map((dto) => company_models.PostedJobOffer(
        id: dto.id,
        title: dto.title,
        totalApplications: dto.totalApplications,
        newApplications: dto.newApplications,
      )).toList();
      
    } catch (e) {
      throw Exception('Error al obtener ofertas publicadas: $e');
    }
  }
}

// --------------------------------------------------------------------------
// 2. Provider del Repositorio
// --------------------------------------------------------------------------

final jobOffersRepositoryProvider = Provider((ref) {
  final apiService = ref.watch(jobOffersApiServiceProvider);
  return JobOffersRepository(apiService);
});