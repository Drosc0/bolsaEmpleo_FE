import 'dart:convert';
import 'package:http/http.dart';

import 'api_client.dart';
import '../models/job_offer.dart';

class OfferService {
  final ApiService _api = ApiService();

  /// Obtiene la lista de ofertas de trabajo con filtros y paginación.
  Future<List<JobOffer>> fetchOffers({
    String? search,
    String? location,
    int page = 1,
    int limit = 10,
  }) async {
    // Construir los parámetros de consulta
    final Map<String, dynamic> params = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (search != null && search.isNotEmpty) 'search': search,
      if (location != null && location.isNotEmpty) 'location': location,
    };
    
    // El cliente HTTP debe manejar la construcción de la URL con parámetros: /offers?page=1...
    final response = await _api.get('/offers', queryParams: params); 

    // Asumimos que el backend devuelve un objeto de paginación: { data: [...], total: ... }
    final jsonResponse = json.decode(response.body);
    final List<dynamic> dataList = jsonResponse['data']; 
    
    return dataList.map((json) => JobOffer.fromJson(json)).toList();
  }

  /// Obtiene los detalles de una oferta específica.
  Future<JobOffer> getOfferDetails(int offerId) async {
    final response = await _api.get('/offers/$offerId');
    final data = json.decode(response.body);
    return JobOffer.fromJson(data);
  }

  /// Obtiene la lista de ofertas creadas por la empresa autenticada.
  Future<List<JobOffer>> fetchCompanyOffers() async {
    final response = await _api.get('/offers/mine'); 
    // Asumiendo que el backend devuelve un array directo
    final List<dynamic> dataList = json.decode(response.body); 
    
    return dataList.map((json) => JobOffer.fromJson(json)).toList();
  }

  /// Crear una nueva oferta (POST /companies/offers)
  Future<JobOffer> createOffer(Map<String, dynamic> offerData) async {
    final response = await _api.post('/companies/offers', offerData);
    final data = json.decode(response.body);
    return JobOffer.fromJson(data);
  }

  /// Actualizar una oferta existente (PUT /companies/offers/:id)
  Future<JobOffer> updateOffer(int offerId, Map<String, dynamic> offerData) async {
    final response = await _api.put('/companies/offers/$offerId', offerData);
    final data = json.decode(response.body);
    return JobOffer.fromJson(data);
  }
  
  // Opcional: Función para eliminar
  Future<void> deleteOffer(int offerId) async {
    await _api.delete('/companies/offers/$offerId');
  }
}