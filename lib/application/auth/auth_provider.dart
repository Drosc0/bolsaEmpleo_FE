import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/services/auth_api_service.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart'; mas adelante

// 1. STATE: Estado global de Autenticación

enum AuthStatus { checking, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final AuthResponse? authData; // Contiene el token y userId

  AuthState({
    required this.status,
    this.authData,
  });

  // Estado inicial: Revisando la sesión
  factory AuthState.initial() => AuthState(status: AuthStatus.checking);

  AuthState copyWith({
    AuthStatus? status,
    AuthResponse? authData,
  }) {
    return AuthState(
      status: status ?? this.status,
      authData: authData ?? this.authData,
    );
  }
}

// 2. NOTIFIER: Lógica de la Sesión Global

class AuthNotifier extends StateNotifier<AuthState> {
  // Simulación de almacenamiento seguro (reemplazar con SecureStorage)
  String? _storedToken; 

  AuthNotifier() : super(AuthState.initial()) {
    // Intentar cargar la sesión al inicio
    checkAuthStatus();
  }

  // Verificar estado de autenticación (simulado)
  Future<void> checkAuthStatus() async {
    // Simular lectura de storage (SecureStorage.read(key: 'token'))
    await Future.delayed(const Duration(milliseconds: 500)); 
    
    // Si encontramos un token válido
    if (_storedToken != null && _storedToken!.isNotEmpty) {
       // Asume que también carga userId, etc.
       final dummyAuthData = AuthResponse(token: _storedToken!, userId: '123', role: ''); 
       state = state.copyWith(
         status: AuthStatus.authenticated, 
         authData: dummyAuthData
       );
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated, authData: null);
    }
  }

  // Método llamado después de un LOGIN exitoso
  void setAuthenticated(AuthResponse data) {
    // 1. Guardar el token de forma persistente
    _storedToken = data.token; 
    // SecureStorage.write(key: 'token', value: data.token);

    // 2. Actualizar el estado global
    state = state.copyWith(
      status: AuthStatus.authenticated,
      authData: data,
    );
  }

  // Método para cerrar sesión
  void logout() {
    // 1. Limpiar el token del storage
    _storedToken = null;
    // SecureStorage.delete(key: 'token');

    // 2. Actualizar el estado global
    state = AuthState.initial().copyWith(status: AuthStatus.unauthenticated);
  }
}

// 3. PROVIDER

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});