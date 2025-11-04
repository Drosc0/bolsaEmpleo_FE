import 'package:bolsa_empleo/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ViewModels
import './viemodels/auth_view_model.dart';
import './viemodels/recruitment_viewmodel.dart';
import './viemodels/company_offers_view_model.dart';

// Views
import 'views/auth/login_view.dart';
import 'views/aspirant/aspirant_home_view.dart';
import 'views/company/company_home_view.dart';

void main() {
  // 1. Inicializa los ViewModels y Configura el árbol de Providers
  runApp(
    MultiProvider(
      providers: [
        // ViewModel de Autenticación (Necesario para el estado inicial y el flujo de login/logout)
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        
        // ViewModel para la gestión de ofertas de la empresa
        ChangeNotifierProvider(create: (_) => CompanyOffersViewModel()),
        
        // ViewModel para la gestión del perfil del aspirante (CV, habilidades, etc.)
        ChangeNotifierProvider(create: (_) => RecruitmentViewModel()),
      ],
      child: const JobBoardApp(),
    ),
  );
}

class JobBoardApp extends StatelessWidget {
  const JobBoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Escucha al AuthViewModel para determinar qué pantalla mostrar
    final authVM = Provider.of<AuthViewModel>(context);

    return MaterialApp(
      title: 'Bolsa de Empleo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        // Configuración de estilos globales
      ),
      home: FutureBuilder(
        // Espera a que el VM cargue el estado de autenticación (ej. token en SharedPreferences)
        future: authVM.checkAuthStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra una pantalla de carga mientras verifica el token
            return const SplashScreen();
          }
          
          // Lógica de Redirección
          if (authVM.isAuthenticated) {
            // El usuario está logueado. Redirigir según el rol.
            if (authVM.currentUser?.role == UserRole.empresa) {
              return const CompanyHomeView();
            } else if (authVM.currentUser?.role == UserRole.aspirante) {
              return const AspirantHomeView();
            }
            // Si el rol no está definido o es admin, muestra login
            return const LoginView(); 
          } else {
            // El usuario no está logueado
            return const LoginView();
          }
        },
      ),
    );
  }
}

// Widget simple de pantalla de carga
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando autenticación...', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}