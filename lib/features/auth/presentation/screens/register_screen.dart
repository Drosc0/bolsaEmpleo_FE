import 'package:bolsa_empleo/application/auth/register/register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Asumimos que estas constantes están definidas en otro lugar
const String userTypeCompany = 'company';
const String userTypeApplicant = 'applicant';

// Tipo enumerado para manejar la selección de rol localmente
enum UserType { applicant, company }

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  // Solo se necesita el estado para el tipo de usuario, los campos van al ViewModel.
  UserType _selectedUserType = UserType.applicant;

  @override
  void initState() {
    super.initState();
    // Inicializar el ViewModel con el tipo de usuario por defecto
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(registerViewModelProvider.notifier).onUserTypeChange(userTypeApplicant);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Observar el estado y el notificador del RegisterViewModel
    final registerState = ref.watch(registerViewModelProvider);
    final registerNotifier = ref.read(registerViewModelProvider.notifier);
    final theme = Theme.of(context);

    // 2. Escuchar los cambios de estado (errores y éxito de operación)
    ref.listen<RegisterFormState>(registerViewModelProvider, (previous, next) {
      // ⚠️ Manejar el Error
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
          // Opcional: Limpiar el error después de mostrarlo.
          registerNotifier.clearError();
        }
      }
      
      // 🛑 NAVEGACIÓN (Se elimina la lógica de redirección aquí)
      // El éxito del registro debe ser manejado por el AuthProvider
      // actualizando el estado, y el GoRouter redirigirá automáticamente.
    });

    // Función que llama al ViewModel (ahora sin lógica de formulario aquí)
    void onRegisterPressed() {
      // Llama al método del ViewModel.
      // El ViewModel debe encargarse de llamar al AuthProvider al finalizar con éxito.
      registerNotifier.register();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Crear Cuenta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column( 
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Selecciona tu Rol',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            // Selector de Rol (Radio Buttons)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: RadioListTile<UserType>(
                    title: const Text('Aspirante'),
                    value: UserType.applicant,
                    groupValue: _selectedUserType,
                    onChanged: (UserType? value) {
                      if (value != null) {
                        setState(() => _selectedUserType = value);
                        registerNotifier.onUserTypeChange(userTypeApplicant);
                      }
                    },
                    activeColor: theme.colorScheme.primary,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: RadioListTile<UserType>(
                    title: const Text('Empresa'),
                    value: UserType.company,
                    groupValue: _selectedUserType,
                    onChanged: (UserType? value) {
                      if (value != null) {
                        setState(() => _selectedUserType = value);
                        registerNotifier.onUserTypeChange(userTypeCompany);
                      }
                    },
                    activeColor: theme.colorScheme.primary,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Campo de Email
            TextFormField(
              onChanged: registerNotifier.onEmailChange,
              initialValue: registerState.email, 
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // Campo de Contraseña
            TextFormField(
              onChanged: registerNotifier.onPasswordChange,
              initialValue: registerState.password, 
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 40),

            // Botón de Registro
            ElevatedButton(
              onPressed: registerState.isLoading ? null : onRegisterPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              child: registerState.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'Registrarse',
                      style: TextStyle(fontSize: 18),
                    ),
            ),
            const SizedBox(height: 20),

            TextButton(
              onPressed: () => context.go('/login'),
              child: Text('¿Ya tienes una cuenta? Inicia Sesión', style: TextStyle(color: theme.colorScheme.secondary)),
            ),
          ],
        ),
      ),
    );
  }
}