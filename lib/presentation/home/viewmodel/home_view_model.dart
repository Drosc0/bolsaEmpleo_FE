import 'package:bolsa_empleo/data/models/job_offer_model.dart';
import 'package:bolsa_empleo/data/repositories/recruitment_repository.dart';
import 'package:bolsa_empleo/data/repositories/applications_repository.dart';
import 'package:flutter/material.dart';
import '../../../data/models/stats_model.dart';

enum ViewState { initial, loading, loaded, error }

class HomeViewModel extends ChangeNotifier {
  final RecruitmentRepository recruitmentRepository;
  final ApplicationsRepository applicationsRepository;

  HomeViewModel({
    required this.recruitmentRepository,
    required this.applicationsRepository,
  }) {
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
      // 1. Obtener ofertas
      _offers = await recruitmentRepository.getLatestJobOffers();

      // 2. Obtener estadísticas
      _stats = await recruitmentRepository.getAppStats();

      _state = ViewState.loaded;
    } catch (e) {
      // por si no enchufa o juega al telefono escacharrao con BE
      _errorMessage = 'Fallo al cargar datos del backend: ${e.toString()}';
      _state = ViewState.error;
      print('Error en HomeViewModel: $e');
    }
    notifyListeners();
  }

  Future<void> applyToJob(int offerId) async {
    try {
      await applicationsRepository.applyToJob(offerId);
    } catch (e) {
      rethrow;
    }
  }
}
