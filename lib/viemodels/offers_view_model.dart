import 'package:flutter/foundation.dart';
import '../services/offer_service.dart';
import '../models/job_offer.dart';

class OffersViewModel extends ChangeNotifier {
  final OfferService _offerService = OfferService();

  // Estado de la Lista de Ofertas
  List<JobOffer> _offers = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Estado de Paginación y Filtros
  int _currentPage = 1;
  bool _hasMore = true;
  String _currentSearch = '';
  String _currentLocation = '';

  // Getters Públicos
  List<JobOffer> get offers => _offers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;

  // --- Lógica Principal de Búsqueda y Carga ---

  /// Carga la primera página de ofertas aplicando los filtros actuales.
  Future<void> loadInitialOffers() async {
    _currentPage = 1;
    _offers = [];
    _hasMore = true;
    
    return _fetchOffers(isInitialLoad: true);
  }
  
  /// Carga la siguiente página de ofertas.
  Future<void> loadNextPage() {
    if (_isLoading || !_hasMore) {
      return Future.value();
    }
    _currentPage++;
    return _fetchOffers(isInitialLoad: false);
  }

  /// Función central para llamar al servicio y actualizar el estado.
  Future<void> _fetchOffers({required bool isInitialLoad}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newOffers = await _offerService.fetchOffers(
        search: _currentSearch,
        location: _currentLocation,
        page: _currentPage,
        limit: 10,
      );

      if (isInitialLoad) {
        _offers = newOffers;
      } else {
        _offers.addAll(newOffers);
      }
      
      // Lógica simple para saber si hay más páginas
      if (newOffers.length < 10) {
        _hasMore = false;
      }

    } catch (e) {
      _errorMessage = 'Error al cargar ofertas: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- Lógica de Filtros (Llamada desde la UI) ---

  void applyFilters({String? search, String? location}) {
    // Si los filtros han cambiado, reinicia la búsqueda
    if (search != null) {
      _currentSearch = search;
    }
    if (location != null) {
      _currentLocation = location;
    }
    loadInitialOffers();
  }
}