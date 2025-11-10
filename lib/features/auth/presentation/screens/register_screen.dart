import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../application/auth/auth_provider.dart';

// Tipo enumerado para manejar la selección de rol localmente
enum UserType { applicant, company }

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  // Estado local para los campos del formulario
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Estado para el tipo de usuario seleccionado
  UserType _selectedUserType = UserType.applicant;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final userType = _selectedUserType == UserType.applicant ? 'applicant' : 'company';

      // Llamada al proveedor de autenticación
      final success = await ref.read(authProvider.notifier).registerUser(
        email: email,
        password: password,
        userType: userType, 
      );

      if (success && mounted) {
        // Navegar al home específico usando GoRouter
        if (userType == 'company') {
          context.go('/company');
        } else {
          context.go('/applicant');
        }
      } else {
        // Mostrar un error (usar un snackbar o modal, no alert)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al registrar. Intenta de nuevo.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Observar el estado de autenticación para deshabilitar el botón si está cargando
    final isLoading = ref.watch(authProvider).status == AuthStatus.checking;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Crear Cuenta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
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
                        if (value != null) setState(() => _selectedUserType = value);
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
                        if (value != null) setState(() => _selectedUserType = value);
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
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Ingresa un correo válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo de Contraseña
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),

              // Botón de Registro
              ElevatedButton(
                onPressed: isLoading ? null : _onRegisterPressed,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20, 
                        width: 20, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
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
      ),
    );
  }
}