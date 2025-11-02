import 'package:flutter/foundation.dart';
import '../services/offer_service.dart';
import '../models/job_offer.dart';

class CompanyOffersViewModel extends ChangeNotifier {
  final OfferService _offerService = OfferService();

  // Estado
  List<JobOffer> _myOffers = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters Públicos
  List<JobOffer> get myOffers => _myOffers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Carga la lista de ofertas creadas por la empresa actual.
  Future<void> loadMyOffers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _myOffers = await _offerService.fetchCompanyOffers();
    } catch (e) {
      _errorMessage = 'Error al cargar las ofertas: ${e.toString()}';
      _myOffers = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Permite recargar la lista de ofertas (útil después de crear/editar una).
  Future<void> refreshOffers() => loadMyOffers();
}