import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/repositories/user_profile_repository.dart'; 
import '../../auth/auth_provider.dart'; 

// -------------------------------------------------------------------
// 1. MODELOS DE DOMINIO
// -------------------------------------------------------------------

class Experience {
  final String id;
  final String title;
  final String company;
  final DateTime startDate;
  final DateTime? endDate;
  final String description;

  Experience({
    required this.id,
    required this.title,
    required this.company,
    required this.startDate,
    this.endDate,
    required this.description,
  });
}

class UserProfile {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String summary;
  final List<Experience> experience;

  UserProfile({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.summary,
    required this.experience,
  });

  // Método para crear una nueva instancia inmutable con campos actualizados
  UserProfile copyWith({
    String? name,
    String? phone,
    String? summary,
    List<Experience>? experience,
  }) {
    return UserProfile(
      userId: userId,
      name: name ?? this.name,
      email: email, // El email no se actualiza
      phone: phone ?? this.phone,
      summary: summary ?? this.summary,
      experience: experience ?? this.experience,
    );
  }
}

// -------------------------------------------------------------------
// 2. ESTADO DEL PERFIL
// -------------------------------------------------------------------

enum ProfileStatus { initial, loading, loaded, saving, error }

class UserProfileState {
  final ProfileStatus status;
  final UserProfile? profile;
  final String? errorMessage;

  UserProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.errorMessage,
  });

  UserProfileState copyWith({
    ProfileStatus? status,
    UserProfile? profile, // Permitir pasar null para limpiar
    String? errorMessage, // Permitir pasar null para limpiar
  }) => UserProfileState(
    status: status ?? this.status,
    profile: profile, 
    errorMessage: errorMessage,
  );
}

// -------------------------------------------------------------------
// 3. VIEwMODEL/NOTIFIER
// -------------------------------------------------------------------

class UserProfileViewModel extends StateNotifier<UserProfileState> {
  final UserProfileRepository _repository; 
  final String _userId; 

  UserProfileViewModel(this._repository, this._userId) 
      : super(UserProfileState()) {
    // Cargar el perfil automáticamente al inicializarse si tenemos un ID
    if (_userId.isNotEmpty) {
      loadProfile();
    }
  }

  /// Carga el perfil completo desde el repositorio.
  Future<void> loadProfile() async {
    if (_userId.isEmpty) {
        state = state.copyWith(status: ProfileStatus.error, errorMessage: 'ID de usuario no disponible.');
        return;
    }
      
    state = state.copyWith(status: ProfileStatus.loading, errorMessage: null);
    try {
      final profile = await _repository.fetchProfile(_userId);
      state = state.copyWith(status: ProfileStatus.loaded, profile: profile);
    } catch (e) {
      state = state.copyWith(
        status: ProfileStatus.error, 
        errorMessage: 'Error al cargar el perfil: ${e.toString()}',
      );
    }
  }

  /// Actualiza los campos básicos del perfil.
  Future<void> updateBasicProfile({
    required String name,
    required String phone,
    required String summary,
  }) async {
    if (state.profile == null) return;

    state = state.copyWith(status: ProfileStatus.saving, errorMessage: null);
    try {
      // 1. Crear una copia local del perfil con los nuevos datos
      final updatedProfile = state.profile!.copyWith(
        name: name,
        phone: phone,
        summary: summary,
      );

      // 2. Llamar al repositorio para guardar en el backend
      await _repository.updateProfile(updatedProfile);

      // 3. Éxito: Actualizar el estado con el perfil guardado
      state = state.copyWith(status: ProfileStatus.loaded, profile: updatedProfile);

    } catch (e) {
      // 4. Fallo: Volver al estado cargado anterior y mostrar error
      state = state.copyWith(
        status: ProfileStatus.loaded, 
        errorMessage: 'Fallo al guardar: ${e.toString()}',
      );
    }
  }
  
  // -------------------------------------------------------------------
  // MÉTODOS DE GESTIÓN DE EXPERIENCIA
  // -------------------------------------------------------------------

  Future<void> addExperience(Experience newExperience) async {
    if (state.profile == null) return;
    
    state = state.copyWith(status: ProfileStatus.saving, errorMessage: null);
    try {
      // 1. Llamar al repositorio (obtiene el objeto con el ID generado por el backend)
      final createdExperience = await _repository.addExperience(_userId, newExperience);

      // 2. Crear una nueva lista inmutable de experiencias
      final updatedExperience = [...state.profile!.experience, createdExperience];
      
      // 3. Crear una copia del perfil con la nueva lista
      final updatedProfile = state.profile!.copyWith(experience: updatedExperience);

      // 4. Actualizar el estado
      state = state.copyWith(status: ProfileStatus.loaded, profile: updatedProfile);

    } catch (e) {
      state = state.copyWith(
        status: ProfileStatus.loaded, 
        errorMessage: 'Fallo al añadir experiencia: ${e.toString()}',
      );
    }
  }

  Future<void> updateExperience(Experience updatedExperience) async {
    if (state.profile == null) return;
    
    state = state.copyWith(status: ProfileStatus.saving, errorMessage: null);
    try {
      // 1. Llamar al repositorio (actualiza en el backend)
      await _repository.updateExperience(_userId, updatedExperience);

      // 2. Mapear la lista de experiencias para reemplazar el objeto actualizado
      final updatedList = state.profile!.experience.map((exp) {
        return exp.id == updatedExperience.id ? updatedExperience : exp;
      }).toList();
      
      // 3. Actualizar el perfil y el estado
      final updatedProfile = state.profile!.copyWith(experience: updatedList);
      state = state.copyWith(status: ProfileStatus.loaded, profile: updatedProfile);

    } catch (e) {
      state = state.copyWith(
        status: ProfileStatus.loaded, 
        errorMessage: 'Fallo al actualizar experiencia: ${e.toString()}',
      );
    }
  }
  
  Future<void> deleteExperience(String experienceId) async {
    if (state.profile == null) return;
    
    state = state.copyWith(status: ProfileStatus.saving, errorMessage: null);
    try {
      // 1. Llamar al repositorio (elimina en el backend)
      await _repository.deleteExperience(_userId, experienceId);

      // 2. Filtrar la lista de experiencias para eliminar el objeto
      final updatedList = state.profile!.experience.where((exp) => exp.id != experienceId).toList();
      
      // 3. Actualizar el perfil y el estado
      final updatedProfile = state.profile!.copyWith(experience: updatedList);
      state = state.copyWith(status: ProfileStatus.loaded, profile: updatedProfile);

    } catch (e) {
      state = state.copyWith(
        status: ProfileStatus.loaded, 
        errorMessage: 'Fallo al eliminar experiencia: ${e.toString()}',
      );
    }
  }
}

// -------------------------------------------------------------------
// 4.PROVIDER
// -------------------------------------------------------------------

final userProfileViewModelProvider = 
    StateNotifierProvider.autoDispose<UserProfileViewModel, UserProfileState>((ref) {
  
  final authData = ref.watch(authProvider).authData;
  final profileRepo = ref.watch(userProfileRepositoryProvider); 
  
  // Obtenemos el ID del usuario
  final userId = authData?.userId ?? ''; 

  return UserProfileViewModel(profileRepo, userId);
});