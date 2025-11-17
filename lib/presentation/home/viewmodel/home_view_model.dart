import 'package:bolsa_empleo/data/models/job_offer_model.dart';
import 'package:bolsa_empleo/data/repositories/recruitment_repository.dart';
import 'package:flutter/material.dart';
import '../../../data/models/stats_model.dart';

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
      // 1. Obtener ofertas REALES
      _offers = await repository.getLatestJobOffers();
      
      // 2. Obtener estadísticas REALES
      _stats = await repository.getAppStats(); 
      
      _state = ViewState.loaded;
    } catch (e) {
      // Ahora este error capturará problemas reales de conexión o del backend
      _errorMessage = 'Fallo al cargar datos del backend: ${e.toString()}';
      _state = ViewState.error;
      print('Error en HomeViewModel: $e');
    }
    notifyListeners();
  }
}