import 'package:flutter/foundation.dart';
import 'package:bolsa_empleo/models/aspirant_profile.dart';
import 'package:bolsa_empleo/models/skill_item.dart'; 
import 'package:bolsa_empleo/models/experience_item.dart';
import '../services/profile_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileService _profileService = ProfileService(); 
  
  // Estado
  AspirantProfile? _profile;
  bool _isLoadingProfile = false;
  bool _isSaving = false;
  String? _errorMessage; 

  // Getters Públicos
  AspirantProfile? get profile => _profile;
  bool get isLoadingProfile => _isLoadingProfile;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  // Constructor para cargar datos al inicio (si es necesario)
  // ProfileViewModel() { fetchProfile(); } 

  // --- Funciones de Lógica de Perfil ---

  /// Carga el perfil completo del aspirante.
  Future<void> fetchProfile() async {
    _isLoadingProfile = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Asumimos que getMyProfile devuelve Future<AspirantProfile?>
      _profile = await _profileService.getMyProfile();
    } catch (e) {
      _errorMessage = 'Error al cargar el perfil: ${e.toString()}';
      _profile = null;
    } finally {
      _isLoadingProfile = false;
      notifyListeners();
    }
  }

  /// Actualiza los campos básicos del perfil.
  Future<bool> updateProfile(Map<String, dynamic> updateData) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Asumimos que updateProfile devuelve Future<AspirantProfile>
      final updatedProfile = await _profileService.updateProfile(updateData);
      _profile = updatedProfile;
      return true;
    } catch (e) {
      _errorMessage = 'Error al actualizar perfil: ${e.toString()}';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // --- Habilidades ---

  /// Añade una nueva habilidad y refresca el estado local.
  Future<bool> addSkill(String name, String category, String level) async {
    if (_profile == null) return false;
    
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final SkillItem newSkill = await _profileService.addSkill(name, category, level); 
      
      // Actualizar la lista inmutablemente
      _profile = _profile!.copyWith(skills: [..._profile!.skills, newSkill]); 
      return true;
    } catch (e) {
      _errorMessage = 'Error al añadir habilidad: ${e.toString()}';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Elimina una habilidad y refresca el estado local.
  Future<bool> removeSkill(int skillId) async {
    if (_profile == null) return false;
    
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      await _profileService.removeSkill(skillId);
      
      // Actualizar la lista inmutablemente
      final updatedSkills = _profile!.skills.where((s) => s.id != skillId).toList();
      _profile = _profile!.copyWith(skills: updatedSkills);
      return true;
    } catch (e) {
      _errorMessage = 'Error al eliminar habilidad: ${e.toString()}';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
  
  // --- Experiencia Laboral ---

  /// Añade un nuevo ítem de experiencia al perfil.
  Future<bool> addExperience(Map<String, dynamic> experienceData) async {
    if (_profile == null) return false;
    
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final ExperienceItem newExperience = await _profileService.addExperience(experienceData);
      
      // Actualización Inmutable
      _profile = _profile!.copyWith(
        experience: [..._profile!.experience, newExperience]
      );
      return true;
    } catch (e) {
      _errorMessage = 'Error al añadir experiencia: ${e.toString()}';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Elimina un ítem de experiencia del perfil por su ID.
  Future<bool> removeExperience(int experienceId) async {
    if (_profile == null) return false;
    
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      await _profileService.removeExperience(experienceId);
      
      // Filtrar la lista localmente (Actualización Inmutable)
      final updatedExperience = _profile!.experience.where((exp) => exp.id != experienceId).toList();
      _profile = _profile!.copyWith(experience: updatedExperience);
      return true;
    } catch (e) {
      _errorMessage = 'Error al eliminar experiencia: ${e.toString()}';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}