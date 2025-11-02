import 'package:flutter/foundation.dart';
import '../services/profile_service.dart';
import '../models/aspirant_profile.dart';
import '../models/skill.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  
  // Estado
  AspirantProfile? _profile;
  bool _isLoadingProfile = false;
  String? _profileError;
  bool _isSaving = false;

  // Getters Públicos
  AspirantProfile? get profile => _profile;
  bool get isLoadingProfile => _isLoadingProfile;
  bool get isSaving => _isSaving;

  // --- Funciones de Lógica ---

  /// Carga el perfil completo del aspirante desde el backend.
  Future<void> fetchProfile() async {
    _isLoadingProfile = true;
    _profileError = null;
    notifyListeners();

    try {
      _profile = await _profileService.getMyProfile();
    } catch (e) {
      _profileError = 'Error al cargar el perfil: ${e.toString()}';
      _profile = null;
    } finally {
      _isLoadingProfile = false;
      notifyListeners();
    }
  }

  /// Actualiza los campos básicos del perfil.
  Future<bool> updateProfile(Map<String, dynamic> updateData) async {
    _isSaving = true;
    notifyListeners();
    
    try {
      final updatedProfile = await _profileService.updateProfile(updateData);
      _profile = updatedProfile;
      return true;
    } catch (e) {
      // Manejo de errores de actualización
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // --- Habilidades y Experiencia ---

  /// Añade una nueva habilidad y refresca el estado local.
  Future<void> addSkill(String name, String category, int level) async {
    if (_profile == null) return;
    
    try {
      final newSkill = await _profileService.addSkill(name, category, level);
      
      // Actualizar la lista localmente (MVVM pattern)
      _profile = _profile!.copyWith(skills: [..._profile!.skills, newSkill]); 
      
      notifyListeners();
    } catch (e) {
      // Manejar error de habilidad
    }
  }
  
  // (La lógica para remover habilidades o gestionar experiencia sigue un patrón similar)
}

// ⚠️ Nota: Necesitarías un método copyWith en tu modelo AspirantProfile
// para hacer la actualización de listas inmutable (buena práctica en Flutter).