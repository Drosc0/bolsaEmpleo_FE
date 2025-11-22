import 'package:flutter/material.dart';
import '../../../../data/repositories/profile_repository.dart';
import '../../../../data/repositories/applications_repository.dart';
import '../../../../data/repositories/job_repository.dart';
import '../../../../data/models/profile_model.dart';
import '../../../../data/models/application_model.dart';
import '../../../../data/models/job_offer_model.dart';

enum DashboardState { loading, loaded, error }

class ApplicantDashboardViewModel extends ChangeNotifier {
  final ProfileRepository profileRepository;
  final ApplicationsRepository applicationsRepository;
  final JobRepository jobRepository;

  ApplicantDashboardViewModel({
    required this.profileRepository,
    required this.applicationsRepository,
    required this.jobRepository,
  }) {
    fetchDashboardData();
  }

  DashboardState _state = DashboardState.loading;
  Profile? _profile;
  List<Application> _applications = [];
  List<JobOffer> _jobOffers = [];
  String? _errorMessage;

  // Getters
  DashboardState get state => _state;
  Profile? get profile => _profile;
  List<Application> get applications => _applications;
  List<JobOffer> get jobOffers => _jobOffers;
  String? get errorMessage => _errorMessage;

  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final updatedProfile = await profileRepository.updateProfile(profileData);
      _profile = updatedProfile;
      notifyListeners();
    } catch (e) {
      print('ERROR UPDATING PROFILE: $e');
      _errorMessage = 'Error al actualizar perfil: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> applyToOffer(int offerId) async {
    try {
      await applicationsRepository.applyToJob(offerId);
      // Refresh applications list
      _applications = await applicationsRepository.getMyApplications();
      notifyListeners();
    } catch (e) {
      print('ERROR APPLYING TO OFFER: $e');
      _errorMessage = 'Error al postularse: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchDashboardData() async {
    _state = DashboardState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Fetch profile, applications, and job offers in parallel
      final results = await Future.wait([
        profileRepository.getMyProfile(),
        applicationsRepository.getMyApplications(),
        jobRepository.getJobOffers(),
      ]);

      _profile = results[0] as Profile;
      _applications = results[1] as List<Application>;
      _jobOffers = results[2] as List<JobOffer>;
      _state = DashboardState.loaded;
    } catch (e) {
      print('ERROR DASHBOARD: $e');
      _errorMessage = 'Error al cargar datos: $e';
      _state = DashboardState.error;
    }

    notifyListeners();
  }
}
