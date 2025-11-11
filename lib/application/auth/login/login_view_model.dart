import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bolsa_empleo/application/auth/auth_provider.dart';

// Definición del estado del formulario de Login
class LoginFormState {
  final String email;
  final String password;
  final bool isLoading;
  final String? errorMessage;

  LoginFormState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.errorMessage,
  });

  LoginFormState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    // El errorMessage se pasa como null para limpiar el error
    String? errorMessage, 
  }) => LoginFormState(
    email: email ?? this.email,
    password: password ?? this.password,
    isLoading: isLoading ?? this.isLoading,
    errorMessage: errorMessage, // Se asigna directamente (puede ser null)
  );
}

// Notifier para la lógica del formulario de Login
class LoginViewModel extends StateNotifier<LoginFormState> {
  final AuthNotifier authNotifier;

  LoginViewModel(this.authNotifier) : super(LoginFormState());

  void onEmailChange(String value) {
    state = state.copyWith(email: value, errorMessage: null);
  }

  void onPasswordChange(String value) {
    state = state.copyWith(password: value, errorMessage: null);
  }

  void resetState() {
    state = LoginFormState();
  }
  
  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }

  // Método de LOGIN: llama al AuthNotifier con los datos del estado
  Future<bool> login() async {
    if (state.email.isEmpty || state.password.isEmpty) {
      state = state.copyWith(errorMessage: 'Rellena todos los campos.');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final success = await authNotifier.loginUser(
        email: state.email,
        password: state.password,
      );

      if (!success) {
        //El login falló (AuthNotifier ya cambió el estado global si era necesario)
        state = state.copyWith(
          isLoading: false, 
          errorMessage: 'Credenciales incorrectas o error en el servidor.',
        );
      } else {
        //Login exitoso. GoRouter ya está redirigiendo.
        // Solo limpiamos el estado local del formulario.
        state = state.copyWith(
          isLoading: false, 
          email: '', // Opcional: limpiar los campos
          password: '',
        );
      }
      
      // Si es exitoso, el AuthNotifier cambia el estado global y GoRouter redirige.
      return success;
    } catch (e) {
      // Error de conexión o excepción inesperada.
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().contains('Exception:') 
            ? e.toString().replaceFirst('Exception: ', '') 
            : 'Error desconocido durante el inicio de sesión.',
      );
      return false;
    }
  }
}

final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginFormState>((ref) {
  // Observa el Notifier del AuthProvider para inyectarlo en el ViewModel
  final authNotifier = ref.watch(authProvider.notifier);
  return LoginViewModel(authNotifier);
});