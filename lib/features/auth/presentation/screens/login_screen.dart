import 'package:bolsa_empleo/application/auth/login/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Observar estado y notificador
    final loginState = ref.watch(loginViewModelProvider);
    final loginNotifier = ref.read(loginViewModelProvider.notifier);

    // 2. Mostrar errores con SnackBar
    ref.listen<LoginFormState>(loginViewModelProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
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

              // EMAIL
              TextFormField(
                onChanged: loginNotifier.onEmailChange,
                initialValue: loginState.email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // PASSWORD
              TextFormField(
                onChanged: loginNotifier.onPasswordChange,
                initialValue: loginState.password,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 32),

              // BOTÓN LOGIN
              ElevatedButton(
                onPressed: loginState.isLoading
                    ? null
                    : () async {
                        final success = await loginNotifier.login();

                        if (success && context.mounted) {
                          // ¡CLAVE! Navegar a raíz para que GoRouter redirija por rol
                          context.go('/');
                        }
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: loginState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Entrar', style: TextStyle(fontSize: 16)),
              ),

              const SizedBox(height: 20),

              // REGISTRO
              TextButton(
                onPressed: loginState.isLoading
                    ? null
                    : () {
                        context.go('/register');
                        loginNotifier.resetState();
                      },
                child: const Text(
                  '¿No tienes cuenta? Regístrate aquí.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}