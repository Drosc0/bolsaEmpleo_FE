import 'package:bolsa_empleo/core/di/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bolsa_empleo/application/auth/auth_provider.dart';

// -------------------------------------------------------------------
// TIPOS Y ESTADO
// -------------------------------------------------------------------

// Usamos estos strings para mapear con la lógica del backend
const String userTypeApplicant = 'applicant';
const String userTypeCompany = 'company';

class RegisterFormState {
  final String email;
  final String password;
  final String userType; // 'applicant' o 'company'
  final bool isLoading;
  final String? errorMessage;

  RegisterFormState({
    this.email = '',
    this.password = '',
    this.userType = userTypeApplicant, // Valor por defecto
    this.isLoading = false,
    this.errorMessage,
  });

  RegisterFormState copyWith({
    String? email,
    String? password,
    String? userType,
    bool? isLoading,
    String? errorMessage,
  }) => RegisterFormState(
    email: email ?? this.email,
    password: password ?? this.password,
    userType: userType ?? this.userType,
    isLoading: isLoading ?? this.isLoading,
    // Nota: Si errorMessage es nulo (para limpiar), debe pasarse explícitamente.
    errorMessage: errorMessage, 
  );
}

// -------------------------------------------------------------------
// NOTIFIER
// -------------------------------------------------------------------

// Asumo que tu authProvider.notifier tiene el tipo AuthNotifier
class RegisterViewModel extends StateNotifier<RegisterFormState> {
  final AuthNotifier authNotifier; 

  RegisterViewModel(this.authNotifier) : super(RegisterFormState());

  void onEmailChange(String value) {
    state = state.copyWith(email: value, errorMessage: null);
  }

  void onPasswordChange(String value) {
    state = state.copyWith(password: value, errorMessage: null);
  }
  
  void onUserTypeChange(String value) {
    // Aseguramos que solo sean los valores permitidos
    if (value == userTypeApplicant || value == userTypeCompany) {
      state = state.copyWith(userType: value, errorMessage: null);
    }
  }

  // 🟢 MÉTODO AÑADIDO: Para que la pantalla pueda limpiar el error después de mostrarlo.
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  // Método de REGISTRO: llama al AuthNotifier con los datos del estado
  Future<bool> register() async {
    if (state.email.isEmpty || state.password.isEmpty) {
      state = state.copyWith(errorMessage: 'Rellena todos los campos.');
      return false;
    }
    
    // Validación mínima de contraseña
    if (state.password.length < 6) {
      state = state.copyWith(errorMessage: 'La contraseña debe tener al menos 6 caracteres.');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final success = await authNotifier.registerUser(
        email: state.email,
        password: state.password,
        userType: state.userType, // Enviamos el rol seleccionado
      );

      if (!success) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Error al registrar. El correo podría ya estar en uso.',
        );
      }
      // Si es exitoso, el AuthNotifier cambia el estado global y GoRouter redirige.
      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().contains('Exception:') 
          ? e.toString().replaceFirst('Exception: ', '') 
          : 'Error desconocido durante el registro.',
      );
      return false;
    }
  }
}

final registerViewModelProvider = StateNotifierProvider<RegisterViewModel, RegisterFormState>((ref) {
  final authNotifier = ref.watch(authProvider.notifier);
  return RegisterViewModel(authNotifier);
});