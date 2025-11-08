import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../application/auth/register/register_view_model.dart'; 

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Instancias para manejar el texto de los campos
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    // 2. Observar el estado y el notificador
    final registerState = ref.watch(registerViewModelProvider);
    final registerNotifier = ref.read(registerViewModelProvider.notifier);

    // 3. Escuchar los cambios de estado (para navegación y mensajes)
    ref.listen<RegisterState>(registerViewModelProvider, (previous, next) {
      // Manejar el Error
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
        // Opcional: limpiar el error después de mostrarlo si el ViewModel no lo hace
        // registerNotifier.resetState(); 
      }
      
      // Manejar el Éxito
      if (next.isRegistered && next.isRegistered != previous?.isRegistered) {
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Registro exitoso! Por favor, inicia sesión.'),
            backgroundColor: Colors.green,
          ),
        );
        // Navegar a la pantalla de Login y cerrar la pantalla actual
        context.go('/login');
        
        // Es importante resetear el estado del ViewModel después de la navegación
        registerNotifier.resetState(); 
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre Completo'),
              ),
              const SizedBox(height: 16),
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
                onPressed: registerState.isLoading
                    ? null // Deshabilitar si está cargando
                    : () {
                        // Llamar al ViewModel
                        registerNotifier.register(
                          emailController.text,
                          passwordController.text,
                          nameController.text,
                        );
                      },
                child: registerState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Crear Cuenta'),
              ),

              const SizedBox(height: 20),
              
              TextButton(
                onPressed: () {
                  // Navegar a Login si el usuario ya tiene cuenta
                  context.go('/login');
                  registerNotifier.resetState(); // Limpiar el estado al salir
                },
                child: const Text('¿Ya tienes una cuenta? Inicia sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}