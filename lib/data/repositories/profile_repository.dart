import 'dart:convert';
import '../models/profile_model.dart';
import '../../core/services/api_service.dart';
import '../../core/services/secure_storage_service.dart';

class ProfileRepository {
  final ApiService apiService;
  final SecureStorageService storageService;

  ProfileRepository({required this.apiService, required this.storageService});

  // Quien soy? A donde voy? de donde vengo? Aqui pido mis datos.
  Future<Profile> getMyProfile() async {
    final token = await storageService.readToken();

    final response = await apiService.get('/recruitment/profile', token: token);

    final Map<String, dynamic> json = jsonDecode(response.body);
    return Profile.fromJson(json);
  }

  // Cambio de look. Actualizo mi perfil para estar mas guapo.
  Future<Profile> updateProfile(Map<String, dynamic> profileData) async {
    final token = await storageService.readToken();

    final response = await apiService.put(
      '/recruitment/profile',
      profileData,
      token: token,
    );

    final Map<String, dynamic> json = jsonDecode(response.body);
    return Profile.fromJson(json);
  }
}
