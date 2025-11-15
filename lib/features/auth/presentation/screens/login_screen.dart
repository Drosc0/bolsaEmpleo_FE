import 'package:bolsa_empleo/application/auth/login/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Observar el estado y el notificador
    final loginState = ref.watch(loginViewModelProvider);
    final loginNotifier = ref.read(loginViewModelProvider.notifier);

    // 2. Escuchar los cambios de estado (solo para mostrar errores)
    ref.listen<LoginFormState>(loginViewModelProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        if (context.mounted) { 
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
          //Limpiar el error después de mostrarlo para evitar que se muestre de nuevo.
          loginNotifier.clearError();
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              
              TextFormField(
                onChanged: loginNotifier.onEmailChange,
                initialValue: loginState.email,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                onChanged: loginNotifier.onPasswordChange,
                initialValue: loginState.password,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: loginState.isLoading
                    ? null // Deshabilitar si está cargando
                    : () async {
                        // El ViewModel ya tiene los datos por los onChanged.
                        final success = await loginNotifier.login(); // Esperar el resultado del login
                        
                        // Si el login es exitoso, forzar la navegación a la raíz.
                        // GoRouter tomará este cambio de ruta, verá que AuthStatus es authenticated,
                        // y el Redirect lo enviará a /applicant o /company según el rol, o eso espero.
                        if (success && context.mounted) {
                            context.go('/'); 
                        }
                      },
                child: loginState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Entrar'),
              ),

              const SizedBox(height: 20),
              
              TextButton(
                onPressed: loginState.isLoading
                    ? null
                    : () {
                        context.go('/register');
                        // Limpiamos el estado al navegar para empezar de cero
                        loginNotifier.resetState(); 
                      },
                child: const Text('¿No tienes cuenta? Regístrate aquí.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
