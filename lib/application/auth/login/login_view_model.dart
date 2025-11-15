import 'package:bolsa_empleo/core/di/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:bolsa_empleo/application/auth/auth_provider.dart'; 

// ----------------------------------------------------------------------
// 1. ESTADO DEL FORMULARIO
// ----------------------------------------------------------------------
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
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool get canSubmit => email.isNotEmpty && password.isNotEmpty && isValidEmail;
}

// ----------------------------------------------------------------------
// 2. VIEWMODEL
// ----------------------------------------------------------------------
class LoginViewModel extends StateNotifier<LoginFormState> {
  final AuthNotifier _authNotifier;
  final Ref _ref;

  LoginViewModel(this._authNotifier, this._ref) : super(LoginFormState());

  void onEmailChange(String value) {
    state = state.copyWith(email: value.trim(), errorMessage: null);
  }

  void onPasswordChange(String value) {
    state = state.copyWith(password: value, errorMessage: null);
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }

  void resetState() {
    state = LoginFormState();
  }

  Future<bool> login() async {
    if (state.email.isEmpty || state.password.isEmpty) {
      state = state.copyWith(errorMessage: 'Completa todos los campos.');
      return false;
    }

    if (!state.isValidEmail) {
      state = state.copyWith(errorMessage: 'Ingresa un email válido.');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final success = await _authNotifier.loginUser(
        email: state.email,
        password: state.password,
      );

      if (success) {
        state = state.copyWith(isLoading: false, email: '', password: '');
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Email o contraseña incorrectos.',
        );
        return false;
      }
    } catch (e) {
      final message = e.toString();
      final cleanMessage = message.contains('Exception:')
          ? message.replaceFirst('Exception: ', '')
          : 'Error de conexión. Intenta de nuevo.';

      state = state.copyWith(isLoading: false, errorMessage: cleanMessage);
      return false;
    }
  }
}

// ----------------------------------------------------------------------
// 3. PROVIDER
// ----------------------------------------------------------------------
final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginFormState>((ref) {
  final authNotifier = ref.watch(authProvider.notifier);
  return LoginViewModel(authNotifier, ref);
});