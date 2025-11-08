import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../application/auth/login/login_view_model.dart'; // Importa el ViewModel

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Instancias para manejar el texto de los campos
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    // 2. Observar el estado y el notificador
    final loginState = ref.watch(loginViewModelProvider);
    final loginNotifier = ref.read(loginViewModelProvider.notifier);

    // 3. Escuchar los cambios de estado (solo para mostrar errores)
    ref.listen<LoginState>(loginViewModelProvider, (previous, next) {
      // Manejar el Error
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        // Asegurarse de que el widget aún esté montado
        if (context.mounted) { 
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
      
      // NOTA: No necesitamos manejar la navegación de éxito aquí.
      // La navegación de éxito ocurre AUTOMÁTICAMENTE a través del app_router, 
      // ya que el LoginNotifier actualiza el authProvider global.
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
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: loginState.isLoading
                    ? null // Deshabilitar si está cargando
                    : () {
                        // 4. Llamar al ViewModel para iniciar la autenticación
                        loginNotifier.login(
                          emailController.text,
                          passwordController.text,
                        );
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
                        // Navegar a Registro
                        context.go('/register');
                        // Opcional: limpiar el estado del login al navegar fuera
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