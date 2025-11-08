import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/services/dio_provider.dart'; // Importa el DioProvider

// --------------------------------------------------------------------------
// 1. Modelos (DTOs)
// --------------------------------------------------------------------------

// Modelo de datos para las ofertas que recibe el Aspirante (similar a JobOffer en ViewModel)
class JobOfferDto {
  final String id;
  final String title;
  final String company;
  final String location;

  JobOfferDto({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
  });

  factory JobOfferDto.fromJson(Map<String, dynamic> json) => JobOfferDto(
    id: json['id'],
    title: json['title'],
    company: json['company_name'] ?? 'Empresa Desconocida',
    location: json['location'] ?? 'N/A',
  );
}

// Modelo de datos para las ofertas publicadas por la Empresa (similar a PostedJobOffer en ViewModel)
class PostedJobOfferDto {
  final String id;
  final String title;
  final int totalApplications;
  final int newApplications;
  final String status; // Ej: 'Activa', 'Cerrada'

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

// --------------------------------------------------------------------------
// 2. Servicio API
// --------------------------------------------------------------------------

class JobOffersApiService {
  final Dio _dio;

  JobOffersApiService(this._dio);

  // 1. Obtener ofertas sugeridas para un aspirante
  Future<List<JobOfferDto>> getRecommendedOffers(String userId) async {
    // Ejemplo de endpoint: /offers/recommended?userId=...
    final response = await _dio.get('/offers/recommended', queryParameters: {'userId': userId});
    
    // Mapear la lista de JSONs a lista de DTOs
    final List<dynamic> data = response.data;
    return data.map((json) => JobOfferDto.fromJson(json)).toList();
  }

  // 2. Obtener ofertas publicadas por una empresa
  Future<List<PostedJobOfferDto>> getPostedOffers(String companyId) async {
    // Ejemplo de endpoint: /company/offers?companyId=...
    final response = await _dio.get('/company/offers', queryParameters: {'companyId': companyId});
    
    // Mapear la lista de JSONs a lista de DTOs
    final List<dynamic> data = response.data;
    return data.map((json) => PostedJobOfferDto.fromJson(json)).toList();
  }
  
  // queeda implementar getAppliedOffers(userId) para el dashboard del usuario.
}

// --------------------------------------------------------------------------
// 3. Provider
// --------------------------------------------------------------------------

final jobOffersApiServiceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return JobOffersApiService(dio);
});