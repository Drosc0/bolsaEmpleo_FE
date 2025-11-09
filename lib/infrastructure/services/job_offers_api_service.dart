import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/services/dio_provider.dart';

// --------------------------------------------------------------------------
// 1. Modelos (DTOs)
// --------------------------------------------------------------------------

// Modelo de datos para las ofertas que recibe el Aspirante (COMPLETO)
class JobOfferDto {
  final String id;
  final String title;
  final String company;
  final String location;
  final String contractType;
  final int minSalary;
  final int maxSalary;
  final String description;
  final String postedDate; // Se recibirá como String (ISO 8601) y se parseará en el Repositorio

  JobOfferDto({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    // 🚨 CAMPOS REQUERIDOS 🚨
    required this.contractType,
    required this.minSalary,
    required this.maxSalary,
    required this.description,
    required this.postedDate,
  });

  factory JobOfferDto.fromJson(Map<String, dynamic> json) => JobOfferDto(
    id: json['id'],
    title: json['title'],
    company: json['company_name'] ?? 'Empresa Desconocida',
    location: json['location'] ?? 'N/A',
    // 🚨 Mapeo de campos requeridos 🚨
    contractType: json['contract_type'] ?? 'N/A',
    minSalary: json['min_salary'] ?? 0,
    maxSalary: json['max_salary'] ?? 0,
    description: json['description'] ?? '',
    postedDate: json['posted_date'],
  );
}

// Modelo de datos para las ofertas publicadas por la Empresa
class PostedJobOfferDto {
  final String id;
  final String title;
  final int totalApplications;
  final int newApplications;
  final String status; 

  PostedJobOfferDto({
    required this.id,
    required this.title,
    required this.totalApplications,
    required this.newApplications,
    required this.status,
  });

  factory PostedJobOfferDto.fromJson(Map<String, dynamic> json) => PostedJobOfferDto(
    id: json['id'],
    title: json['title'],
    totalApplications: json['totalApplications'] ?? 0,
    newApplications: json['newApplications'] ?? 0,
    status: json['status'] ?? 'Activa',
  );
}

// DTO para el historial de postulaciones del aspirante
class JobApplicationDto {
  final String id;
  final String jobOfferId;
  final String jobTitle; 
  final String companyName;
  final String status; 
  final String appliedAt;

  JobApplicationDto({
    required this.id,
    required this.jobOfferId,
    required this.jobTitle,
    required this.companyName,
    required this.status,
    required this.appliedAt,
  });
  
  factory JobApplicationDto.fromJson(Map<String, dynamic> json) => JobApplicationDto(
    id: json['id'],
    jobOfferId: json['job_offer_id'],
    jobTitle: json['job_title'] ?? 'Título Desconocido',
    companyName: json['company_name'] ?? 'N/A',
    status: json['status'],
    appliedAt: json['applied_at'], 
  );
}

// DTO para la lista de aspirantes por oferta (Empresa)
class ApplicantDetailDto {
  final String applicantId;
  final String name;
  final String email;
  final String applicationStatus;
  final String appliedAt;

  ApplicantDetailDto({
    required this.applicantId,
    required this.name,
    required this.email,
    required this.applicationStatus,
    required this.appliedAt,
  });
  
  factory ApplicantDetailDto.fromJson(Map<String, dynamic> json) => ApplicantDetailDto(
    applicantId: json['applicant_id'],
    name: json['name'],
    email: json['email'],
    applicationStatus: json['application_status'],
    appliedAt: json['applied_at'],
  );
}


// --------------------------------------------------------------------------
// 2. Servicio API
// --------------------------------------------------------------------------

class JobOffersApiService {
  final Dio _dio;

  JobOffersApiService(this._dio);

  // 1. Obtener ofertas sugeridas para un aspirante
  Future<List<JobOfferDto>> getRecommendedOffers(String userId) async {
    final response = await _dio.get('/offers/recommended', queryParameters: {'userId': userId});
    final List<dynamic> data = response.data;
    return data.map((json) => JobOfferDto.fromJson(json)).toList();
  }

  // 2. Obtener ofertas publicadas por una empresa
  Future<List<PostedJobOfferDto>> getPostedOffers(String companyId) async {
    final response = await _dio.get('/company/offers', queryParameters: {'companyId': companyId});
    final List<dynamic> data = response.data;
    return data.map((json) => PostedJobOfferDto.fromJson(json)).toList();
  }
  
  // 3. Obtener historial de postulaciones del aspirante
  Future<List<JobApplicationDto>> getAppliedOffers(String userId) async {
    final response = await _dio.get('/applicant/applications', queryParameters: {'userId': userId});
    final List<dynamic> data = response.data;
    return data.map((json) => JobApplicationDto.fromJson(json)).toList();
  }
  
  // 4. Publicar una nueva oferta (Empresa) 
  Future<void> createJobOffer({
    required String companyId,
    required String title,
    required String description,
    required String location,
    required String contractType,
    required int minSalary,
    required int maxSalary,
  }) async {
    await _dio.post(
      '/company/jobs',
      data: {
        'companyId': companyId,
        'title': title,
        'description': description,
        'location': location,
        'contract_type': contractType,
        'min_salary': minSalary,
        'max_salary': maxSalary,
      },
    );
  }
  
  // 5. Obtener postulantes para una oferta específica (Empresa)
  Future<List<ApplicantDetailDto>> getApplicantsByOffer(String jobOfferId) async {
    final response = await _dio.get('/company/jobs/$jobOfferId/applicants');
    final List<dynamic> data = response.data;
    return data.map((json) => ApplicantDetailDto.fromJson(json)).toList();
  }

  // 6. NUEVO: Actualizar el estado de una postulación (Empresa)
  Future<void> updateApplicationStatus({
    required String applicationId,
    required String newStatus,
  }) async {
    await _dio.patch(
      '/applications/$applicationId/status',
      data: {
        'status': newStatus, // Ej: 'interview', 'rejected', 'hired'
      },
    );
    // Nota: Si la API devuelve el objeto actualizado, podrías devolverse aquí.
  }
}

// --------------------------------------------------------------------------
// 3. Provider
// --------------------------------------------------------------------------

final jobOffersApiServiceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return JobOffersApiService(dio);
});