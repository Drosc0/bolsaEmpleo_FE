import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../application/auth/login/login_view_model.dart'; 

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

   @override
   Widget build(BuildContext context, WidgetRef ref) {
      // 1. OBSERVAMOS EL ESTADO DEL VIEwMODEL (LoginState)
      final loginState = ref.watch(loginViewModelProvider);
      // 2. ACCEDEMOS AL NOTIFIER (MÉTODOS)
      final loginNotifier = ref.read(loginViewModelProvider.notifier);
  
      // Controladores de edición local
      // Nota: En un ConsumerWidget, estos se recrearán en cada rebuild, 
      // pero para formularios simples es aceptable.
      final emailController = TextEditingController(); 
      final passwordController = TextEditingController();

      // 3. ESCUCHAMOS LOS CAMBIOS DE ESTADO PARA NAVEGAR
      ref.listen<LoginState>(loginViewModelProvider, (previous, current) {
      // Si pasa a autenticado, navegamos a la Home
      if (current.isAuthenticated) {
        // Es crucial que el AuthProvider global actualice el estado de autenticación
        // después de este punto, para que GoRouter no redirija de vuelta.
       context.go('/'); 
      }
 
      // Si hay un mensaje de error, lo mostramos
      if (current.errorMessage != null && current.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
                      content: Text('Error: ${current.errorMessage}'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                  ),
        );
      }
    });

    return Scaffold (
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          //El Container aplica la restricción de ancho máximo (maxWidth: 400)
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400), 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Bienvenido de Nuevo',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Campo Email
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Campo Contraseña
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                // Botón de Login
                ElevatedButton(
                  // Deshabilitar si isLoading es true
                  onPressed: loginState.isLoading ? null : () {
                    // Llamada al método del Notifier
                    loginNotifier.login(
                    emailController.text, 
                    passwordController.text
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: loginState.isLoading 
                  ? const SizedBox(
                    height: 20, width: 20, 
                    child: CircularProgressIndicator(strokeWidth: 2)
                  )
                  : const Text('Entrar', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 16),
    
                // Botón para ir al Registro
                TextButton(
                  onPressed: () => context.go('/register'),
                  child: const Text('¿No tienes cuenta? Regístrate'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}