import 'package:bolsa_empleo/infrastructure/services/auth_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../infrastructure/services/auth_api_service.dart';

// 1. STATE: Definimos el estado que queremos que la UI observe

class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;

  LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isAuthenticated,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// 2. VIEwMODEL/NOTIFIER: Lógica de negocio

class LoginNotifier extends StateNotifier<LoginState> {
  final AuthApiService _authService;

  LoginNotifier(this._authService) : super(LoginState());

  Future<void> login(String email, String password) async {
    // 1. Iniciar carga y limpiar errores previos
    state = state.copyWith(isLoading: true, errorMessage: null);

    final dto = LoginDto(email: email, password: password);

    try {
      // 2. Llamada al servicio real (Data Layer)
      final response = await _authService.login(dto);

      // 3. Éxito: Actualizar el estado a autenticado
      // Aquí se guardaría el token en un Secure Storage
      print('Token recibido: ${response.token}'); 
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        errorMessage: null,
      );

    } on Exception catch (e) {
      // 4. Fallo: Capturar excepción y establecer mensaje de error
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}

// 3. PROVIDER: Inyectar el Notifier

final loginViewModelProvider = StateNotifierProvider.autoDispose<LoginNotifier, LoginState>((ref) {
  final authService = ref.watch(authApiServiceProvider);
  return LoginNotifier(authService);
});