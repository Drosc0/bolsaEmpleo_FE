import 'package:flutter/foundation.dart';
import '../models/job_offer.dart';
import '../services/offer_service.dart';
import '../services/application_service.dart';

class OfferDetailsViewModel extends ChangeNotifier {
  final OfferService _offerService = OfferService();
  final ApplicationService _applicationService = ApplicationService();

  JobOffer? _offer;
  bool _isLoading = false;
  bool _isApplying = false;
  String? _errorMessage;
  String? _successMessage;

  // Getters
  JobOffer? get offer => _offer;
  bool get isLoading => _isLoading;
  bool get isApplying => _isApplying;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  // --- Funciones de Lógica ---

  /// Carga los detalles completos de la oferta.
  Future<void> fetchOfferDetails(int offerId) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      _offer = await _offerService.getOfferDetails(offerId);
    } catch (e) {
      _errorMessage = 'Error al cargar los detalles: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Postula al usuario a la oferta actual.
  Future<void> applyToOffer() async {
    if (_offer == null) return;
    
    _isApplying = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _applicationService.applyToOffer(_offer!.id);
      _successMessage = '¡Postulación enviada con éxito!';
    } catch (e) {
      _errorMessage = 'Error al postularse: ${e.toString()}';
    } finally {
      _isApplying = false;
      notifyListeners();
    }
  }
}