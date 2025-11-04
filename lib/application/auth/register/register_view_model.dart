import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../infrastructure/services/auth_api_service.dart'; // Servicio real

// 1. STATE: Definimos el estado que queremos que la UI observe

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
      errorMessage: errorMessage,
      isRegistered: isRegistered ?? this.isRegistered,
    );
  }
}

// 2. VIEwMODEL/NOTIFIER: Lógica de negocio

class RegisterNotifier extends StateNotifier<RegisterState> {
  final AuthApiService _authService;

  RegisterNotifier(this._authService) : super(RegisterState());

  Future<void> register(String email, String password, String name) async {
    // 1. Iniciar carga y limpiar errores previos
    state = state.copyWith(isLoading: true, errorMessage: null);

    final dto = RegisterDto(email: email, password: password, name: name);

    try {
      // 2. Llamada al servicio real (Data Layer)
      // Asumiendo que el método register en AuthApiService devuelve true al éxito
      final success = await _authService.register(dto);

      // 3. Éxito: Actualizar el estado
      state = state.copyWith(
        isLoading: false,
        isRegistered: success,
        errorMessage: null,
      );

    } on Exception catch (e) {
      // 4. Fallo: Capturar excepción y establecer mensaje de error
      state = state.copyWith(
        isLoading: false,
        isRegistered: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}

// 3. PROVIDER: Inyectar el Notifier

final registerViewModelProvider = StateNotifierProvider.autoDispose<RegisterNotifier, RegisterState>((ref) {
  final authService = ref.watch(authApiServiceProvider);
  return RegisterNotifier(authService);
});