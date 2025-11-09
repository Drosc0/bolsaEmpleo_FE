import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/applicant/user_home_view_model.dart' as applicant_models;
import '../../application/company/company_home_view_model.dart' as company_models;
import '../../domain/models/applicant_model.dart';
import '../../domain/models/job_application.dart';
import '../../infrastructure/services/job_offers_api_service.dart'; 


// ----------------------
// 1. Repositorio (Clase)
// -----------------------

class JobOffersRepository {
  final JobOffersApiService _apiService;

  JobOffersRepository(this._apiService);

  // -----------------------------
  // A. Métodos para el Aspirante
  // ------------------------------
  
  /// Obtiene ofertas de trabajo recomendadas para un usuario específico.
  Future<List<applicant_models.JobOffer>> fetchRecommendedOffers(String userId) async {
    try {
      final dtos = await _apiService.getRecommendedOffers(userId);
      
      // Mapear DTOs a Modelos de Dominio (ViewModel)
      return dtos.map((dto) => applicant_models.JobOffer(
        id: dto.id,
        title: dto.title,
        company: dto.company,
        location: dto.location,
        contractType: dto.contractType,
        minSalary: dto.minSalary,
        maxSalary: dto.maxSalary,
        description: dto.description,
        // Asegúrate de que JobOffer tiene un constructor que acepta todos estos campos nombrados
        postedDate: DateTime.parse(dto.postedDate),
      )).toList();
      
    } catch (e) {
      throw Exception('Error al obtener ofertas recomendadas: $e');
    }
  }
  
  /// Obtiene el historial de postulaciones de un aspirante.
  Future<List<JobApplication>> fetchAppliedOffers(String userId) async {
    try {
      final dtos = await _apiService.getAppliedOffers(userId);
      
      return dtos.map((dto) => JobApplication(
        id: dto.id,
        jobOfferId: dto.jobOfferId,
        // En una app real, el applicantId vendría del contexto de autenticación o del DTO
        applicantId: userId, 
        // Asumo que tienes una función o constructor para manejar el mapeo de status
        status: JobApplication.statusFromString(dto.status),
        appliedAt: DateTime.parse(dto.appliedAt),
      )).toList();
      
    } catch (e) {
      throw Exception('Error al obtener postulaciones: $e');
    }
  }


  // --------------------------
  // B. Métodos para la Empresa
  // --------------------------
  
  /// Obtiene las ofertas publicadas por una empresa, incluyendo métricas de postulación.
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

  /// Crea y publica una nueva oferta de trabajo.
  Future<void> createJobOffer({
    required String companyId,
    required String title,
    required String description,
    required String location,
    required String contractType,
    required int minSalary,
    required int maxSalary,
  }) async {
    try {
      await _apiService.createJobOffer(
        companyId: companyId,
        title: title,
        description: description,
        location: location,
        contractType: contractType,
        minSalary: minSalary,
        maxSalary: maxSalary,
      );

    } catch (e) {
      throw Exception('Fallo al publicar la oferta: $e');
    }
  }

  /// Obtiene la lista de postulantes para una oferta de trabajo específica.
  Future<List<ApplicantModel>> fetchApplicantsForOffer(String jobOfferId) async {
    try {
      final List<ApplicantDetailDto> dtos = await _apiService.getApplicantsByOffer(jobOfferId);

      return dtos.map((dto) => ApplicantModel(
        id: dto.applicantId,
        name: dto.name,
        email: dto.email,
        status: dto.applicationStatus, 
        appliedAt: DateTime.parse(dto.appliedAt),
      )).toList();
      
    } catch (e) {
      throw Exception('Error al obtener postulantes para la oferta $jobOfferId: $e');
    }
  }
  
  /// Cambia el estado de una postulación (ej. de 'Enviada' a 'Entrevista').
  Future<void> updateApplicationStatus({
    required String applicationId,
    required String newStatus,
  }) async {
    try {
      await _apiService.updateApplicationStatus(
        applicationId: applicationId,
        newStatus: newStatus,
      );
    } catch (e) {
      throw Exception('Error al actualizar el estado de la postulación: $e');
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