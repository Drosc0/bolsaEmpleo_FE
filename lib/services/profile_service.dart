import 'dart:convert';
import '../models/aspirant_profile.dart';
import '../models/skill_item.dart'; 
import '../models/experience_item.dart';
import 'api_client.dart';

class ProfileService {
  final ApiService _api = ApiService();

  // --- Perfil Base (Correcto) ---
  
  // Obtener el perfil completo del aspirante autenticado
  Future<AspirantProfile> getMyProfile() async {
    final response = await _api.get('/aspirants/profile');
    final data = json.decode(response.body);
    return AspirantProfile.fromJson(data);
  }

  // Actualizar el perfil base (ej: summary, phone)
  Future<AspirantProfile> updateProfile(Map<String, dynamic> updateData) async {
    final response = await _api.put('/aspirants/profile', updateData);
    final data = json.decode(response.body);
    return AspirantProfile.fromJson(data);
  }

  // --- Habilidades ---

  /// Añadir una nueva habilidad
  Future<SkillItem> addSkill(String name, String category, String level) async {
    final response = await _api.post('/aspirants/skills', {
      'name': name,
      'category': category,
      'level': level, // Se envía como String
    });
    final data = json.decode(response.body);
    return SkillItem.fromJson(data);
  }

  // Eliminar una habilidad
  Future<void> removeSkill(int skillId) async {
    await _api.delete('/aspirants/skills/$skillId');
  }
  
  // --- Experiencia (Correcto) ---
  
  Future<ExperienceItem> addExperience(Map<String, dynamic> experienceData) async {
    final response = await _api.post('/aspirants/experience', experienceData);
    final data = json.decode(response.body);
    return ExperienceItem.fromJson(data);
  }

  Future<void> removeExperience(int experienceId) async {
    await _api.delete('/aspirants/experience/$experienceId');
  }
}