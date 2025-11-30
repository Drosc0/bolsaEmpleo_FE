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
  List<Application> _recentApplications = [];
  String? _errorMessage;

  // Getters
  DashboardState get state => _state;
  CompanyProfile? get companyProfile => _companyProfile;
  List<JobOffer> get jobOffers => _jobOffers;
  List<Application> get recentApplications => _recentApplications;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDashboardData() async {
    _state = DashboardState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Pido el perfil y las ofertas a la vez, para acabar antes.
      // que los nenucos de hoy no saben esperar
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

      // Fetch recent applications for all offers
      await fetchRecentApplications();

      _state = DashboardState.loaded;
    } catch (e) {
      print('ERROR COMPANY DASHBOARD: $e');
      _errorMessage = 'Error al cargar datos: $e';
      _state = DashboardState.error;
    }

    notifyListeners();
  }

  List<dynamic> _recentActivity = [];
  List<dynamic> get recentActivity => _recentActivity;

  Future<void> fetchRecentApplications() async {
    try {
      List<Application> allApplications = [];

      // Fetch applications for each job offer
      for (final offer in _jobOffers) {
        final apps = await companyRepository.getApplicationsForOffer(offer.id);
        allApplications.addAll(apps);
      }

      _recentApplications = allApplications;

      // Combine offers and applications
      _recentActivity = [..._jobOffers, ..._recentApplications];

      // Sort by date (most recent first)
      _recentActivity.sort((a, b) {
        DateTime dateA;
        DateTime dateB;

        if (a is JobOffer) {
          dateA = a.createdAt;
        } else {
          dateA = (a as Application).appliedAt;
        }

        if (b is JobOffer) {
          dateB = b.createdAt;
        } else {
          dateB = (b as Application).appliedAt;
        }

        return dateB.compareTo(dateA);
      });

      // Take top 10 items
      _recentActivity = _recentActivity.take(10).toList();
    } catch (e) {
      print('ERROR FETCHING RECENT APPLICATIONS: $e');
      _recentApplications = [];
      _recentActivity = [];
    }
  }

  // para ver a quien engañas, creas nuevo pacto con el diablo
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
      // el mensaje que mas vi durante el desarrollo
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
