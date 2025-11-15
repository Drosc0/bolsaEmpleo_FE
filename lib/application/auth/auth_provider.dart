import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/services/auth_api_service.dart';
import '../../config/services/secure_storage_service.dart';
import '../../infrastructure/models/auth_response.dart'; 

// ----------------------------------------------------------------------
// 1. STATE y STATUS
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
      // Si status es unauthenticated, forzamos authData a ser null
      authData: status == AuthStatus.unauthenticated ? null : authData ?? this.authData,
    );
  }
}

// ----------------------------------------------------------------------
// 2. NOTIFIER: Lógica de la Sesión Global
// ----------------------------------------------------------------------

class AuthNotifier extends StateNotifier<AuthState> {
  final SecureStorageService _storageService; 
  final AuthApiService _authService; 

  AuthNotifier(this._storageService, this._authService) : super(AuthState.initial()) {
    // Intentar cargar la sesión al inicio
    checkAuthStatus();
  }

  // Verificar estado de autenticación al inicio de la app
  Future<void> checkAuthStatus() async {
    // 1. Leer los datos desde el Secure Storage
    final token = await _storageService.readToken();
    final userId = await _storageService.readUserId();
    final role = await _storageService.readRole();
    
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

  // ------------------------------------
  // MÉTODOS DE AUTENTICACIÓN
  // ------------------------------------

  // Manejo de Registro
  Future<bool> registerUser({
    required String email,
    required String password,
    required String userType, // 'applicant' o 'company'
  }) async {
    try {
      state = state.copyWith(status: AuthStatus.checking);
      
      final authResponse = await _authService.register(
        email: email,
        password: password,
        userType: userType, 
      );
      
      // Si el backend devuelve AuthResponse (registro exitoso)
      setAuthenticated(authResponse);
      return true;
    } catch (e) {
      // Manejo de excepción
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return false;
    }
  }

  // Manejo de Login
  Future<bool> loginUser({required String email, required String password}) async {
    try {
      state = state.copyWith(status: AuthStatus.checking); 
      
      final authResponse = await _authService.login(email: email, password: password);
      
      // Si la llamada a la API es exitosa, llama a setAuthenticated (que actualiza el estado).
      setAuthenticated(authResponse);
      return true;
    } catch (e) {
      // Manejo de excepción (Error de conexión, credenciales inválidas, etc.)
      state = state.copyWith(status: AuthStatus.unauthenticated); // Establece el estado final de fallo
      return false;
    }
  }


  // Método llamado después de un LOGIN o REGISTER exitoso
  void setAuthenticated(AuthResponse data) {
    // 1. Guardar los datos de forma persistente (Asíncrono)
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
    state = state.copyWith(status: AuthStatus.unauthenticated, authData: null);
  }
}

// ----------------------------------------------------------------------
// 3. PROVIDER (Inyección de dependencias)
// ----------------------------------------------------------------------

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  // 1. Obtener dependencias
  final storageService = ref.watch(secureStorageServiceProvider);
  final apiService = ref.watch(authApiServiceProvider); 
  
  // 2. Crear el Notifier
  return AuthNotifier(storageService, apiService);
});