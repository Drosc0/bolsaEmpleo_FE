import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/services/auth_api_service.dart';
import '../../config/services/secure_storage_service.dart'; 

// ----------------------------------------------------------------------
// 1. STATE y STATUS (Sin cambios)
// ----------------------------------------------------------------------

enum AuthStatus { checking, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final AuthResponse? authData; // Contiene el token, userId y role

  AuthState({required this.status, this.authData});
  
  factory AuthState.initial() => AuthState(status: AuthStatus.checking);
  
  AuthState copyWith({AuthStatus? status, AuthResponse? authData}) {
    // Permite pasar authData: null para desautenticar
    return AuthState(
      status: status ?? this.status,
      authData: authData,
    );
  }
}

// ----------------------------------------------------------------------
// 2. NOTIFIER: Lógica de la Sesión Global (MODIFICADO)
// ----------------------------------------------------------------------

class AuthNotifier extends StateNotifier<AuthState> {
  final SecureStorageService _storageService; 

  AuthNotifier(this._storageService) : super(AuthState.initial()) {
    // Intentar cargar la sesión al inicio
    checkAuthStatus();
  }

  // Verificar estado de autenticación al inicio de la app
  Future<void> checkAuthStatus() async {
    // 1. Leer los datos desde el Secure Storage
    final token = await _storageService.readToken();
    final userId = await _storageService.readUserId();
    final role = await _storageService.readRole();
    
    // Si encontramos un token, ID y rol válidos
    if (token != null && userId != null && role != null) {
       // 2. Reconstruir el AuthResponse
       final savedAuthData = AuthResponse(token: token, userId: userId, role: role); 
       
       // 3. Establecer como autenticado
       state = state.copyWith(
         status: AuthStatus.authenticated, 
         authData: savedAuthData
       );
    } else {
      // 4. Si falta cualquier dato, desautenticar
      state = state.copyWith(status: AuthStatus.unauthenticated, authData: null);
    }
  }

  // Método llamado después de un LOGIN exitoso
  void setAuthenticated(AuthResponse data) {
    // 1. Guardar el token de forma persistente (Asíncrono, no bloqueante)
    _storageService.setAuthData(
      token: data.token, 
      role: data.role, 
      userId: data.userId
    );

    // 2. Actualizar el estado global
    state = state.copyWith(
      status: AuthStatus.authenticated,
      authData: data,
    );
  }

  // Método para cerrar sesión
  Future<void> logout() async {
    // 1. Limpiar el token del storage (Asíncrono)
    await _storageService.deleteAuthData();

    // 2. Actualizar el estado global
    // Usamos copyWith(authData: null) para asegurar que el token se borra
    state = AuthState.initial().copyWith(status: AuthStatus.unauthenticated, authData: null);
  }
}

// ----------------------------------------------------------------------
// 3. PROVIDER (MODIFICADO para inyectar el storage)
// ----------------------------------------------------------------------

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  // 🆕 Leer e inyectar el servicio de storage
  final storageService = ref.watch(secureStorageServiceProvider);
  return AuthNotifier(storageService);
});