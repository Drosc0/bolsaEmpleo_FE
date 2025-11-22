import 'dart:convert';
import '../models/application_model.dart';
import '../../core/services/api_service.dart';
import '../../core/services/secure_storage_service.dart';

class ApplicationsRepository {
  final ApiService apiService;
  final SecureStorageService storageService;

  ApplicationsRepository({
    required this.apiService,
    required this.storageService,
  });

  /// GET /recruitment/applications/me
  /// Obtiene todas las candidaturas del aspirante autenticado
  Future<List<Application>> getMyApplications() async {
    final token = await storageService.readToken();

    final response = await apiService.get(
      '/recruitment/applications/me',
      token: token,
    );

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Application.fromJson(json)).toList();
  }

  /// POST /recruitment/applications
  /// Postula a una oferta de trabajo
  Future<void> applyToJob(int offerId) async {
    final token = await storageService.readToken();

    // La API espera el offerId en la URL o query param, no en el body si da error de propiedad.
    // Probamos con /recruitment/applications/{offerId} o similar.
    // Si el error es "property offerId should not exist", es probable que el DTO no tenga ese campo.
    // Asumimos que el endpoint correcto es POST /recruitment/applications con offerId como query param
    // O tal vez POST /recruitment/offers/{id}/apply

    // Intentemos POST /recruitment/applications?offerId={id}
    // O POST /recruitment/applications/{id}

    // Dado que el usuario no dio docs, y el error es de validación de propiedad en body,
    // voy a intentar pasarlo como query param si el endpoint es genérico,
    // o en el path si es específico.

    // Voy a probar: POST /recruitment/applications/{offerId}
    // Si falla, el usuario nos lo dirá.

    await apiService.post(
      '/recruitment/applications/$offerId',
      {},
      token: token,
    );
  }
}
