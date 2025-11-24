import 'package:flutter/material.dart';
import '../../../../data/repositories/company_repository.dart';
import '../../../../data/models/company_profile_model.dart';
import '../../../../data/models/job_offer_model.dart';
import '../../../../data/models/application_model.dart';

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
      // Pido el perfil y las ofertas a la vez, para acabar antes.
      final results = await Future.wait([
        companyRepository.getMyCompanyProfile(),
        companyRepository.getMyJobOffers(),
      ]);

      _companyProfile = results[0] as CompanyProfile;
      final allOffers = results[1] as List<JobOffer>;

      // Aqui filtro las ofertas porque el servidor me las da todas y yo solo quiero las mias.
      // Un poco chapuza pero funciona.
      _jobOffers = allOffers
          .where((offer) => offer.companyId == _companyProfile?.id)
          .toList();
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

  Future<List<Application>> fetchApplicationsForOffer(int offerId) async {
    try {
      return await companyRepository.getApplicationsForOffer(offerId);
    } catch (e) {
      print('ERROR FETCHING APPLICATIONS: $e');
      rethrow;
    }
  }

  Future<void> updateApplicationStatus(int applicationId, String status) async {
    try {
      await companyRepository.updateApplicationStatus(applicationId, status);
      notifyListeners();
    } catch (e) {
      print('ERROR UPDATING APPLICATION STATUS: $e');
      rethrow;
    }
  }

  Future<void> updateOffer(int offerId, Map<String, dynamic> offerData) async {
    try {
      final updatedOffer = await companyRepository.updateJobOffer(
        offerId,
        offerData,
      );
      final index = _jobOffers.indexWhere((o) => o.id == offerId);
      if (index != -1) {
        _jobOffers[index] = updatedOffer;
        notifyListeners();
      }
    } catch (e) {
      print('ERROR UPDATING OFFER: $e');
      _errorMessage = 'Error al actualizar oferta: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteOffer(int offerId) async {
    try {
      await companyRepository.deleteJobOffer(offerId);
      _jobOffers.removeWhere((o) => o.id == offerId);
      notifyListeners();
    } catch (e) {
      print('ERROR DELETING OFFER: $e');
      _errorMessage = 'Error al eliminar oferta: $e';
      notifyListeners();
      rethrow;
    }
  }
}
