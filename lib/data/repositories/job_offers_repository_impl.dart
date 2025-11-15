import 'package:dio/dio.dart';
import '../../domain/repositories/job_offers_repository.dart';
import '../../application/applicant/user_home_view_model.dart' as applicant_models;
import '../../application/company/company_home_view_model.dart' as company_models;
import '../../domain/models/applicant_model.dart';
import '../../domain/models/job_application.dart';

class JobOffersRepositoryImpl implements JobOffersRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:3000/api',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // -----------------------------
  // A. Métodos para el Aspirante
  // ------------------------------
  
  @override
  Future<List<applicant_models.JobOffer>> fetchRecommendedOffers(String userId) async {
    try {
      final response = await _dio.get('/offers/recommended?userId=$userId');
      final List<dynamic> data = response.data;
      return data.map((json) => applicant_models.JobOffer.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Error al cargar ofertas recomendadas: ${e.message}');
    }
  }
  
  @override
  Future<List<JobApplication>> fetchAppliedOffers(String userId) async {
    try {
      final response = await _dio.get('/offers/applied?userId=$userId');
      final List<dynamic> data = response.data;
      return data.map((json) => JobApplication.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Error al cargar postulaciones: ${e.message}');
    }
  }

  // --------------------------
  // B. Métodos para la Empresa
  // --------------------------
  
  @override
  Future<List<company_models.PostedJobOffer>> fetchPostedOffers(String companyId) async {
    try {
      final response = await _dio.get('/company/offers?companyId=$companyId');
      final List<dynamic> data = response.data;
      return data.map((json) => company_models.PostedJobOffer.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Error al cargar ofertas publicadas: ${e.message}');
    }
  }

  @override
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
      await _dio.post('/company/offers', data: {
        'companyId': companyId,
        'title': title,
        'description': description,
        'location': location,
        'contractType': contractType,
        'minSalary': minSalary,
        'maxSalary': maxSalary,
      });
    } on DioException catch (e) {
      throw Exception('Fallo al publicar la oferta: ${e.message}');
    }
  }

  @override
  Future<List<ApplicantModel>> fetchApplicantsForOffer(String jobOfferId) async {
    try {
      final response = await _dio.get('/offers/$jobOfferId/applicants');
      final List<dynamic> data = response.data;
      return data.map((json) => ApplicantModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Error al obtener postulantes: ${e.message}');
    }
  }
  
  @override
  Future<void> updateApplicationStatus({
    required String applicationId,
    required String newStatus,
  }) async {
    try {
      await _dio.patch('/applications/$applicationId', data: {'status': newStatus});
    } on DioException catch (e) {
      throw Exception('Error al actualizar estado: ${e.message}');
    }
  }
}