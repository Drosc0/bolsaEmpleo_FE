import 'dart:convert';
import '../models/job_offer_model.dart';
import '../models/stats_model.dart'; 
import '../../core/services/api_service.dart';

class RecruitmentRepository {
  final ApiService apiService;

  RecruitmentRepository({required this.apiService});

  // ==========================================================
  // Obtención de Ofertas desde NestJS
  // Endpoint: GET /api/job-offers/latest (asumiendo que existe)
  // ==========================================================
  Future<List<JobOffer>> getLatestJobOffers() async {
    final response = await apiService.get('/job-offers/latest'); 
    
    // Decodifica la respuesta JSON
    final List<dynamic> jsonList = jsonDecode(response.body);

    // Mapea la lista de JSON a la lista de JobOffer
    return jsonList.map((json) => JobOffer.fromJson(json)).toList();
  }

  // ==========================================================
  // Obtención de Estadísticas desde NestJS
  // Endpoint: GET /api/stats 
  // ==========================================================
  Future<AppStats> getAppStats() async {
    // Nota: Esta ruta debería ser pública para la Home Page
    final response = await apiService.get('/stats'); 
    
    final Map<String, dynamic> json = jsonDecode(response.body);
    
    return AppStats.fromJson(json);
  }
}