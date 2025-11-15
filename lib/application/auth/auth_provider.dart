import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/services/auth_api_service.dart';
import '../../config/services/secure_storage_service.dart';
import '../../infrastructure/models/auth_response.dart';

// ----------------------------------------------------------------------
// 1. ENUM: Estado de autenticación
// ----------------------------------------------------------------------
enum AuthStatus { checking, authenticated, unauthenticated }

// ----------------------------------------------------------------------
// 2. STATE: Datos de la sesión
// ----------------------------------------------------------------------
class AuthState {
  final AuthStatus status;
  final AuthResponse? authData; // token + userId (String) + role

  AuthState({
    required this.status,
    this.authData,
  });

  factory AuthState.initial() => AuthState(status: AuthStatus.checking);

  AuthState copyWith({
    AuthStatus? status,
    AuthResponse? authData,
  }) {
    return AuthState(
      status: status ?? this.status,
      authData: status == AuthStatus.unauthenticated ? null : (authData ?? this.authData),
    );
  }
}

// ----------------------------------------------------------------------
// 3. NOTIFIER: Lógica de autenticación
// ----------------------------------------------------------------------
class AuthNotifier extends StateNotifier<AuthState> {
  final SecureStorageService _storageService;
  final AuthApiService _authService;

  AuthNotifier(this._storageService, this._authService) : super(AuthState.initial()) {
    checkAuthStatus();
  }

  // ------------------------------------------------------------------
  // Verifica si hay sesión guardada al iniciar la app
  // ------------------------------------------------------------------
  Future<void> checkAuthStatus() async {
    try {
      final token = await _storageService.readToken();
      final userId = await _storageService.readUserId(); // ← String?
      final role = await _storageService.readRole();     // ← String?

      if (token != null && userId != null && role != null) {
        final savedAuthData = AuthResponse(
          token: token,
          userId: userId,  // ← String
          role: role,
        );

        state = state.copyWith(
          status: AuthStatus.authenticated,
          authData: savedAuthData,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          authData: null,
        );
      }
    } catch (e) {
      // En caso de error de lectura, forzar logout
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        authData: null,
      );
    }
  }

  // ------------------------------------------------------------------
  // Registro de usuario
  // ------------------------------------------------------------------
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

      await setAuthenticated(authResponse);
      return true;
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return false;
    }
  }

  // ------------------------------------------------------------------
  // Login de usuario
  // ------------------------------------------------------------------
  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(status: AuthStatus.checking);

      final authResponse = await _authService.login(
        email: email,
        password: password,
      );

      await setAuthenticated(authResponse); // ← Espera guardado
      return true;
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return false;
    }
  }

  // ------------------------------------------------------------------
  // Guarda datos en storage + actualiza estado (ASÍNCRONO)
  // ------------------------------------------------------------------
  Future<void> setAuthenticated(AuthResponse data) async {
    try {
      // 1. Guardar en SecureStorage
      await _storageService.setAuthData(
        token: data.token,
        role: data.role,
        userId: data.userId, // ← String → String
      );

      // 2. Solo después, actualizar estado
      state = state.copyWith(
        status: AuthStatus.authenticated,
        authData: data,
      );
    } catch (e) {
      // Si falla el guardado, no autenticar
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  // ------------------------------------------------------------------
  // Cerrar sesión
  // ------------------------------------------------------------------
  Future<void> logout() async {
    await _storageService.deleteAuthData();
    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      authData: null,
    );
  }
}
