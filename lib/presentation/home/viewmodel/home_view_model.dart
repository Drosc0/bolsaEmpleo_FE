import 'package:flutter/material.dart';
import '../../data/models/job_offer_model.dart';
import '../../data/models/stats_model.dart';
import '../../data/repositories/recruitment_repository.dart';

enum ViewState { initial, loading, loaded, error }

class HomeViewModel extends ChangeNotifier {
  final RecruitmentRepository repository;
  
  HomeViewModel({required this.repository}) {
    fetchInitialData();
  }

  ViewState _state = ViewState.initial;
  List<JobOffer> _offers = [];
  AppStats? _stats;
  String? _errorMessage;

  // Getters Públicos
  ViewState get state => _state;
  List<JobOffer> get offers => _offers;
  AppStats? get stats => _stats;
  String? get errorMessage => _errorMessage;

  Future<void> fetchInitialData() async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Nota: Idealmente, el backend tendría un endpoint /stats y /offers
      // Simulamos la carga de ambos
      _offers = await repository.getLatestJobOffers();
      // Temporalmente, simulamos las estadísticas hasta crear el endpoint:
      _stats = AppStats(totalUsers: 150, aspirants: 120, companies: 30);
      
      _state = ViewState.loaded;
    } catch (e) {
      _errorMessage = 'Fallo al cargar datos: ${e.toString()}';
      _state = ViewState.error;
      print('Error en HomeViewModel: $e');
    }
    notifyListeners();
  }
}