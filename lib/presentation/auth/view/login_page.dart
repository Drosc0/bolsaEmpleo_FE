import 'package:bolsa_empleo/presentation/auth/viewmodel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'register_page.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(AuthViewModel viewModel) async {
    // Es importante verificar el contexto para evitar errores si la página se desmonta
    if (!mounted) return;
    
    if (_formKey.currentState!.validate()) {
      bool success = await viewModel.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        // La navegación al Dashboard/Home la maneja el Consumer en main.dart.
        // Solo cerramos la página actual si hubiera algo debajo (ej. si venimos de Home).
        // En este caso, no hacemos nada para dejar que main.dart maneje la ruta.
        print('Login exitoso! Rol: ${viewModel.userRole}');
      } else {
        // Mostrar SnackBar con el error reportado por el ViewModel
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${viewModel.errorMessage ?? "Inténtelo de nuevo"}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthViewModel>(context);
    final isAuthenticating = viewModel.status == AuthStatus.authenticating;

    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value!.isEmpty || !value.contains('@') ? 'Ingrese un email válido' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) => value!.isEmpty ? 'Ingrese su contraseña' : null,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: isAuthenticating ? null : () => _submit(viewModel),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: isAuthenticating
                        ? const Center(child: SizedBox(
                            height: 20, 
                            width: 20, 
                            child: CircularProgressIndicator(strokeWidth: 2.0)
                          ))
                        : const Text('Iniciar Sesión', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: isAuthenticating ? null : () {
                      // Navegar a la página de Registro
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text('¿No tienes cuenta? Regístrate aquí'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}