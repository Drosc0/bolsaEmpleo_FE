import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../infrastructure/services/auth_api_service.dart'; 

// ----------------------------------------------------------------------
// 1. STATE: Estado del Registro
// ----------------------------------------------------------------------

class RegisterState {
  final bool isLoading;
  final String? errorMessage;
  final bool isRegistered;

  RegisterState({
    this.isLoading = false,
    this.errorMessage,
    this.isRegistered = false,
  });

  RegisterState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isRegistered,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      // Usamos 'errorMessage: errorMessage' sin el operador ?? para permitir limpiar el error
      errorMessage: errorMessage, 
      isRegistered: isRegistered ?? this.isRegistered,
    );
  }
}

// ----------------------------------------------------------------------
// 2. VIEwMODEL/NOTIFIER: Lógica de Negocio
// ----------------------------------------------------------------------

class RegisterNotifier extends StateNotifier<RegisterState> {
  final AuthApiService _authService;

  RegisterNotifier(this._authService) : super(RegisterState());

  Future<void> register(String email, String password, String name) async {
    // Validación básica de campos
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Todos los campos son obligatorios.',
      );
      return;
    }

    // 1. Iniciar carga y limpiar errores previos
    state = state.copyWith(isLoading: true, errorMessage: null);

    final dto = RegisterDto(email: email, password: password, name: name);

    try {
      // 2. Llamada al servicio de API
      final success = await _authService.register(dto);

      if (success) {
        // 3. Éxito
        state = state.copyWith(
          isLoading: false,
          isRegistered: true,
          errorMessage: null,
        );
      } else {
        // Fallo inesperado del servicio
        state = state.copyWith(
          isLoading: false,
          isRegistered: false,
          errorMessage: 'El registro falló por una razón desconocida.',
        );
      }
    } on Exception catch (e) {
      // 4. Fallo: Capturar excepción (ej. error 400 de NestJS)
      state = state.copyWith(
        isLoading: false,
        isRegistered: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''), 
      );
    }
  }

  // 🚨 MÉTODO CORREGIDO: Usado para limpiar el estado después de la navegación
  void resetState() {
    state = RegisterState();
  }
}

// ----------------------------------------------------------------------
// 3. PROVIDER: Inyectar el Notifier
// ----------------------------------------------------------------------

final registerViewModelProvider = StateNotifierProvider.autoDispose<RegisterNotifier, RegisterState>((ref) {
  // Inyectar el servicio de autenticación
  final authService = ref.watch(authApiServiceProvider); 
  return RegisterNotifier(authService);
});