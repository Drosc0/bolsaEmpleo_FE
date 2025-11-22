import 'package:flutter/material.dart';
import '../../../../data/repositories/profile_repository.dart';
import '../../../../data/repositories/applications_repository.dart';
import '../../../../data/models/profile_model.dart';
import '../../../../data/models/application_model.dart';

enum DashboardState { loading, loaded, error }

class ApplicantDashboardViewModel extends ChangeNotifier {
  final ProfileRepository profileRepository;
  final ApplicationsRepository applicationsRepository;

  ApplicantDashboardViewModel({
    required this.profileRepository,
    required this.applicationsRepository,
  }) {
    fetchDashboardData();
  }

  DashboardState _state = DashboardState.loading;
  Profile? _profile;
  List<Application> _applications = [];
  String? _errorMessage;

  // Getters
  DashboardState get state => _state;
  Profile? get profile => _profile;
  List<Application> get applications => _applications;
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

  Future<void> fetchDashboardData() async {
    _state = DashboardState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Fetch profile and applications in parallel
      final results = await Future.wait([
        profileRepository.getMyProfile(),
        applicationsRepository.getMyApplications(),
      ]);

      _profile = results[0] as Profile;
      _applications = results[1] as List<Application>;
      _state = DashboardState.loaded;
    } catch (e) {
      print('ERROR DASHBOARD: $e');
      _errorMessage = 'Error al cargar datos: $e';
      _state = DashboardState.error;
    }

    notifyListeners();
  }
}
