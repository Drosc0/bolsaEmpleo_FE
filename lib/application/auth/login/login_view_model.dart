import 'package:flutter_riverpod/flutter_riverpod.dart';
// Importamos el servicio de autenticación para los métodos de API y DTOs
import '../../../infrastructure/services/auth_api_service.dart'; 
// Importamos el proveedor de autenticación global para actualizar la sesión
import '../auth_provider.dart'; 

// ----------------------------------------------------------------------
// 1. STATE: Estado del Login
// ----------------------------------------------------------------------

class LoginState {
  final bool isLoading;
  final String? errorMessage;

  LoginState({
    this.isLoading = false,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      // Usamos 'errorMessage: errorMessage' para permitir limpiar el error
      errorMessage: errorMessage, 
    );
  }
}

// ----------------------------------------------------------------------
// 2. VIEwMODEL/NOTIFIER: Lógica de Negocio
// ----------------------------------------------------------------------

class LoginNotifier extends StateNotifier<LoginState> {
  final AuthApiService _authService;
  // Inyectamos el AuthNotifier para actualizar el estado de la sesión global
  final AuthNotifier _authNotifier; 

  LoginNotifier(this._authService, this._authNotifier) : super(LoginState());

  Future<void> login(String email, String password) async {
    // 1. Validación básica de campos
    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(
        errorMessage: 'El email y la contraseña son obligatorios.',
      );
      return;
    }

    // 2. Iniciar carga y limpiar errores previos
    state = state.copyWith(isLoading: true, errorMessage: null);

    final dto = LoginDto(email: email, password: password);

    try {
      // 3. Llamada al servicio de API
      final authResponse = await _authService.login(dto);

      // 4. Éxito: Notificar al proveedor de autenticación global
      _authNotifier.setAuthenticated(authResponse);

      // 5. Finalizar carga
      state = state.copyWith(isLoading: false);

    } on Exception catch (e) {
      // 6. Fallo: Capturar excepción y establecer mensaje de error
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''), 
      );
    }
  }

  // Método opcional para limpiar el estado si el usuario cancela la operación
  void resetState() {
    state = LoginState();
  }
}

// ----------------------------------------------------------------------
// 3. PROVIDER: Inyectar el Notifier
// ----------------------------------------------------------------------

final loginViewModelProvider = StateNotifierProvider.autoDispose<LoginNotifier, LoginState>((ref) {
  // Inyectar el servicio de autenticación
  final authService = ref.watch(authApiServiceProvider); 
  // Inyectar el Notifier global de autenticación
  final authNotifier = ref.watch(authProvider.notifier);
  
  return LoginNotifier(authService, authNotifier);
});