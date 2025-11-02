import 'package:flutter/foundation.dart';
import '../services/application_service.dart';
import '../models/application.dart';

class OfferApplicationsViewModel extends ChangeNotifier {
  final ApplicationService _applicationService = ApplicationService();
  final int offerId;
  final String offerTitle;

  // Estado
  List<Application> _applications = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Application> get applications => _applications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  OfferApplicationsViewModel({required this.offerId, required this.offerTitle});

  /// Carga la lista de postulaciones para la oferta específica.
  Future<void> fetchApplications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _applications = await _applicationService.getApplicationsByOffer(offerId);
    } catch (e) {
      _errorMessage = 'Error al cargar postulaciones: ${e.toString()}';
      _applications = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Actualiza el estado de una postulación específica.
  Future<bool> updateApplicationStatus(
      int applicationId, ApplicationStatus newStatus,
      {String? comments}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedApp = await _applicationService.updateApplicationStatus(
          offerId, applicationId, newStatus, comments);

      // Actualizar la lista localmente (MVVM)
      final index = _applications.indexWhere((app) => app.id == applicationId);
      if (index != -1) {
        _applications[index] = updatedApp;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = 'Fallo al actualizar el estado: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
    }
  }
}