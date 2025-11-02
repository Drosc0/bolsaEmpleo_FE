import 'dart:convert';

import '../models/application.dart';
import 'api_client.dart';

class ApplicationService {
  final ApiService _api = ApiService();

  // --- Funciones del Aspirante ---

  // Postularse a una oferta
  Future<Application> applyToOffer(int jobOfferId) async {
    final response = await _api.post('/aspirants/applications', {
      'jobOfferId': jobOfferId,
    });
    final data = json.decode(response.body);
    return Application.fromJson(data);
  }

  // Ver todas mis postulaciones
  Future<List<Application>> getMyApplications() async {
    final response = await _api.get('/aspirants/applications');
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Application.fromJson(json)).toList();
  }

  // --- Funciones de la Empresa ---

  // Ver postulaciones para una oferta específica
  Future<List<Application>> getApplicationsByOffer(int offerId) async {
    final response = await _api.get('/companies/offers/$offerId/applications');
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Application.fromJson(json)).toList();
  }

  // Actualizar el estado de una postulación
  Future<Application> updateApplicationStatus(
    int offerId,
    int applicationId,
    ApplicationStatus status,
    String? comments,
  ) async {
    final response = await _api.put(
      '/companies/offers/$offerId/applications/$applicationId',
      {
        'status': status.toJson(), // Usamos el método toJson del enum
        'comments': comments,
      },
    );
    final data = json.decode(response.body);
    return Application.fromJson(data);
  }
}