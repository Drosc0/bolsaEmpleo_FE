import '../../infrastructure/models/auth_response.dart';

// --- 1. Enumeración para el Status ---
enum AuthStatus {
  checking,        // Revisando el token inicial
  authenticated,   // Logueado y con datos
  unauthenticated, // No logueado
}

// --- 2. Clase de Estado Completo (Inmutable) ---
class AuthState {
  final AuthStatus status;
  final AuthResponse? authData; 

  final String? errorMessage;

  AuthState({
    this.status = AuthStatus.checking,
    this.authData,
    this.errorMessage,
  });

  // Método copyWith para Riverpod
  AuthState copyWith({
    AuthStatus? status,
    AuthResponse? authData,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      // Si pasamos authData null explícitamente, significa deslogueo
      authData: authData,
      errorMessage: errorMessage,
    );
  }
}