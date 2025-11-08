import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/services/user_profile_api_service.dart';
import '../../application/applicant/profile/user_profile_view_model.dart' as domain_models;

// --------------------------------------------------------------------------
// 1. Repositorio (Clase)
// --------------------------------------------------------------------------

class UserProfileRepository {
  final UserProfileApiService _apiService;

  UserProfileRepository(this._apiService);

  // Obtener el perfil completo
  Future<domain_models.UserProfile> fetchProfile(String userId) async {
    try {
      final dto = await _apiService.fetchProfile(userId);
      
      // Mapear DTOs de Infraestructura a Modelos de Dominio (ViewModel)
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
      throw Exception('Error al obtener el perfil de usuario: $e');
    }
  }

  // Actualizar el perfil
  Future<void> updateProfile(domain_models.UserProfile profile) async {
    try {
      // Nota: El DTO de perfil en el servicio API debe ser actualizado para manejar 
      // la conversión entre el modelo de dominio y el DTO de actualización.
      
      // Para simplificar, creamos un DTO temporal solo con los datos básicos
      final updateDto = UserProfileDto(
        userId: profile.userId,
        name: profile.name,
        email: profile.email, // Solo para completar DTO, no se actualiza
        phone: profile.phone,
        summary: profile.summary,
        experience: [], // No actualizamos la experiencia aquí
      );
      
      await _apiService.updateProfile(profile.userId, updateDto);
    } catch (e) {
      throw Exception('Error al actualizar el perfil: $e');
    }
  }

  /// Añade una experiencia y devuelve el modelo actualizado con el ID.
  Future<domain_models.Experience> addExperience(String userId, domain_models.Experience experience) async {
    try {
      // 1. Convertir Modelo de Dominio a DTO para el API Service
      final dto = ExperienceDto(
        id: '', // El ID se ignorará en el POST, el backend lo genera
        title: experience.title,
        company: experience.company,
        startDate: experience.startDate,
        endDate: experience.endDate,
        description: experience.description,
      );

      // 2. Llamada a la API
      final createdDto = await _apiService.addExperience(userId, dto);
      
      // 3. Devolver el Modelo de Dominio creado (con el ID generado)
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
  
  /// Actualiza una experiencia existente.
  Future<void> updateExperience(String userId, domain_models.Experience experience) async {
    try {
      // 1. Convertir Modelo de Dominio a DTO
      final dto = ExperienceDto(
        id: experience.id, 
        title: experience.title,
        company: experience.company,
        startDate: experience.startDate,
        endDate: experience.endDate,
        description: experience.description,
      );
      
      // 2. Llamada a la API
      await _apiService.updateExperience(userId, experience.id, dto);

    } catch (e) {
      throw Exception('Error al actualizar experiencia: $e');
    }
  }

  /// Elimina una experiencia por su ID.
  Future<void> deleteExperience(String userId, String experienceId) async {
    try {
      await _apiService.deleteExperience(userId, experienceId);
    } catch (e) {
      throw Exception('Error al eliminar experiencia: $e');
    }
  }
}

// --------------------------------------------------------------------------
// 2. Provider del Repositorio
// --------------------------------------------------------------------------

final userProfileRepositoryProvider = Provider((ref) {
  final apiService = ref.watch(userProfileApiServiceProvider);
  return UserProfileRepository(apiService);
});