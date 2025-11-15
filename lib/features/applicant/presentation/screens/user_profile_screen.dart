import '../../../../application/applicant/profile/user_profile_view_model.dart' as domain_models;

abstract class UserProfileRepository {
  Future<domain_models.UserProfile> fetchProfile(String userId);
  Future<void> updateProfile(domain_models.UserProfile profile);
  Future<domain_models.Experience> addExperience(String userId, domain_models.Experience experience);
  Future<void> updateExperience(String userId, domain_models.Experience experience);
  Future<void> deleteExperience(String userId, String experienceId);

  // NUEVO: Perfil básico para UserHomeScreen
  Future<Map<String, dynamic>> fetchBasicProfile(String userId);
}