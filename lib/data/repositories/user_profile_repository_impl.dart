import 'package:bolsa_empleo/features/applicant/presentation/screens/user_profile_screen.dart';

import '../../infrastructure/services/user_profile_api_service.dart';
import '../../application/applicant/profile/user_profile_view_model.dart' as domain_models;

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileApiService _apiService;

  UserProfileRepositoryImpl(this._apiService);

  @override
  Future<domain_models.UserProfile> fetchProfile(String userId) async {
    try {
      final dto = await _apiService.fetchProfile(userId);
      final experience = dto.experience.map((e) => domain_models.Experience(
        id: e.id,
        title: e.title,
        company: e.company,
        startDate: e.startDate,
        endDate: e.endDate,
        description: e.description,
      )).toList();

      return domain_models.UserProfile(
        userId: dto.userId,
        name: dto.name,
        email: dto.email,
        phone: dto.phone,
        summary: dto.summary,
        experience: experience,
      );
    } catch (e) {
      throw Exception('Error al obtener perfil: $e');
    }
  }

  @override
  Future<void> updateProfile(domain_models.UserProfile profile) async {
    try {
      final updateDto = UserProfileDto(
        userId: profile.userId,
        name: profile.name,
        email: profile.email,
        phone: profile.phone,
        summary: profile.summary,
        experience: [],
      );
      await _apiService.updateProfile(profile.userId, updateDto);
    } catch (e) {
      throw Exception('Error al actualizar perfil: $e');
    }
  }

  @override
  Future<domain_models.Experience> addExperience(String userId, domain_models.Experience experience) async {
    try {
      final dto = ExperienceDto(
        id: '',
        title: experience.title,
        company: experience.company,
        startDate: experience.startDate,
        endDate: experience.endDate,
        description: experience.description,
      );
      final createdDto = await _apiService.addExperience(userId, dto);
      return domain_models.Experience(
        id: createdDto.id,
        title: createdDto.title,
        company: createdDto.company,
        startDate: createdDto.startDate,
        endDate: createdDto.endDate,
        description: createdDto.description,
      );
    } catch (e) {
      throw Exception('Error al añadir experiencia: $e');
    }
  }

  @override
  Future<void> updateExperience(String userId, domain_models.Experience experience) async {
    try {
      final dto = ExperienceDto(
        id: experience.id,
        title: experience.title,
        company: experience.company,
        startDate: experience.startDate,
        endDate: experience.endDate,
        description: experience.description,
      );
      await _apiService.updateExperience(userId, experience.id, dto);
    } catch (e) {
      throw Exception('Error al actualizar experiencia: $e');
    }
  }

  @override
  Future<void> deleteExperience(String userId, String experienceId) async {
    try {
      await _apiService.deleteExperience(userId, experienceId);
    } catch (e) {
      throw Exception('Error al eliminar experiencia: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> fetchBasicProfile(String userId) async {
    try {
      final dto = await _apiService.fetchProfile(userId);
      return {
        'name': dto.name,
        'email': dto.email,
      };
    } catch (e) {
      throw Exception('Error al cargar perfil básico: $e');
    }
  }
}