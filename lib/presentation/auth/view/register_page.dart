import 'package:bolsa_empleo/presentation/auth/viewmodel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';

// Roles disponibles
enum UserRoleOption { aspirant, company }

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Estado para el selector de Rol (defecto: Aspirante)
  UserRoleOption _selectedRole = UserRoleOption.aspirant;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(AuthViewModel viewModel) async {
    if (_formKey.currentState!.validate()) {
      // 1. Mapear el enum de Flutter al string esperado por NestJS
      final roleString = _selectedRole == UserRoleOption.aspirant ? 'aspirante' : 'empresa';
      
      bool success = await viewModel.register(
        _emailController.text,
        _passwordController.text,
        roleString,
      );

      if (success) {
        // Registro exitoso: Navegar al Home o Dashboard
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Registro exitoso!')),
        );
        // Si el login fue automático, el Consumer en main.dart manejará la navegación.
        Navigator.pop(context); 
      } else {
        // Mostrar error del backend
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar: ${viewModel.errorMessage}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthViewModel>(context);
    final isAuthenticating = viewModel.status == AuthStatus.authenticating;

    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Usuario')),
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
                  //1. SELECCIÓN DE ROL
                  _buildRoleSelector(),
                  const SizedBox(height: 30),

                  //2. CAMPOS DE FORMULARIO
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value!.isEmpty || !value.contains('@') ? 'Introduzca un email válido' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña (mínimo 6 caracteres)',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) => value!.length < 6 ? 'La contraseña debe tener al menos 6 caracteres' : null,
                  ),
                  const SizedBox(height: 30),

                  //3. BOTÓN DE REGISTRO
                  ElevatedButton(
                    onPressed: isAuthenticating ? null : () => _submit(viewModel),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: isAuthenticating
                        ? const CircularProgressIndicator()
                        : const Text('Registrarse', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 20),

                  //4. ENLACE A LOGIN
                  TextButton(
                    onPressed: () {
                      // Vuelve a la página de Login
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text('¿Ya tienes cuenta? Inicia Sesión'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget para la selección del rol usando RadioListTile
  Widget _buildRoleSelector() {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecciona tu Rol:',
              style: theme.textTheme.titleMedium,
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<UserRoleOption>(
                    title: const Text('Aspirante'),
                    value: UserRoleOption.aspirant,
                    groupValue: _selectedRole,
                    onChanged: (UserRoleOption? value) {
                      if (value != null) setState(() => _selectedRole = value);
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<UserRoleOption>(
                    title: const Text('Empresa'),
                    value: UserRoleOption.company,
                    groupValue: _selectedRole,
                    onChanged: (UserRoleOption? value) {
                      if (value != null) setState(() => _selectedRole = value);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}