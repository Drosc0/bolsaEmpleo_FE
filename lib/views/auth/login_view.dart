import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viemodels/auth_view_model.dart';
import 'register_view.dart';
import '../aspirant/aspirant_home_view.dart'; 

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      
      await authViewModel.login(
        _emailController.text,
        _passwordController.text,
      );

      if (authViewModel.isLoggedIn && context.mounted) {
        // Navegar a la pantalla principal si el login es exitoso
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AspirantHomeView()),
        );
      } else if (authViewModel.errorMessage != null && context.mounted) {
        // Mostrar error si falla
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authViewModel.errorMessage!)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Consumer<AuthViewModel>(
        builder: (context, authViewModel, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Correo Electrónico'),
                    validator: (value) => value!.isEmpty ? 'Ingresa tu correo' : null,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Contraseña'),
                    obscureText: true,
                    validator: (value) => value!.length < 6 ? 'Contraseña debe tener 6+ caracteres' : null,
                  ),
                  const SizedBox(height: 20),
                  authViewModel.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () => _submitLogin(context),
                          child: const Text('Login'),
                        ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RegisterView()),
                      );
                    },
                    child: const Text('¿No tienes cuenta? Regístrate aquí'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}