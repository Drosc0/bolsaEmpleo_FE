import 'package:flutter/material.dart';
import '../../../../data/repositories/company_repository.dart';
import '../../../../data/models/company_profile_model.dart';
import '../../../../data/models/job_offer_model.dart';

enum DashboardState { loading, loaded, error }

class CompanyDashboardViewModel extends ChangeNotifier {
  final CompanyRepository companyRepository;

  CompanyDashboardViewModel({required this.companyRepository}) {
    fetchDashboardData();
  }

  DashboardState _state = DashboardState.loading;
  CompanyProfile? _companyProfile;
  List<JobOffer> _jobOffers = [];
  String? _errorMessage;

  // Getters
  DashboardState get state => _state;
  CompanyProfile? get companyProfile => _companyProfile;
  List<JobOffer> get jobOffers => _jobOffers;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDashboardData() async {
    _state = DashboardState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Fetch company profile and job offers in parallel
      final results = await Future.wait([
        companyRepository.getMyCompanyProfile(),
        companyRepository.getMyJobOffers(),
      ]);

      _companyProfile = results[0] as CompanyProfile;
      _jobOffers = results[1] as List<JobOffer>;
      _state = DashboardState.loaded;
    } catch (e) {
      print('ERROR COMPANY DASHBOARD: $e');
      _errorMessage = 'Error al cargar datos: $e';
      _state = DashboardState.error;
    }

    notifyListeners();
  }

  Future<void> createOffer(Map<String, dynamic> offerData) async {
    try {
      final newOffer = await companyRepository.createJobOffer(offerData);
      _jobOffers.insert(0, newOffer);
      notifyListeners();
    } catch (e) {
      print('ERROR CREATING OFFER: $e');
      _errorMessage = 'Error al crear oferta: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateCompanyProfile(Map<String, dynamic> profileData) async {
    try {
      final updatedProfile = await companyRepository.updateCompanyProfile(
        profileData,
      );
      _companyProfile = updatedProfile;
      notifyListeners();
    } catch (e) {
      print('ERROR UPDATING PROFILE: $e');
      _errorMessage = 'Error al actualizar perfil: $e';
      notifyListeners();
      rethrow;
    }
  }
}
