import 'package:flutter/foundation.dart';
import '../models/application.dart';
import '../services/application_service.dart';

class MyApplicationsViewModel extends ChangeNotifier {
  final ApplicationService _applicationService = ApplicationService();

  // Estado
  List<Application> _applications = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Application> get applications => _applications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // --- Lógica Principal ---

  /// Carga la lista completa de postulaciones del aspirante autenticado.
  Future<void> fetchMyApplications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _applications = await _applicationService.getMyApplications();
    } catch (e) {
      _errorMessage = 'Error al cargar las postulaciones: ${e.toString()}';
      _applications = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Si implementas la opción de 'Retirar Postulación', la lógica iría aquí:
  // Future<void> withdrawApplication(int applicationId) { ... }
}