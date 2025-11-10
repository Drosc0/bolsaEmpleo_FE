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
    String? errorMessage,
  }) => LoginFormState(
    email: email ?? this.email,
    password: password ?? this.password,
    isLoading: isLoading ?? this.isLoading,
    errorMessage: errorMessage,
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

  // para limpiar el estado del formulario.
  void resetState() {
    state = LoginFormState();
  }
  
  // para limpiar el error después de mostrar el SnackBar.
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
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Credenciales incorrectas o error en el servidor.',
        );
      }
      // Si es exitoso, el AuthNotifier cambia el estado global y GoRouter redirige.
      return success;
    } catch (e) {
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
  final authNotifier = ref.watch(authProvider.notifier);
  return LoginViewModel(authNotifier);
});