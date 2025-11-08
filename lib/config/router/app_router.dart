import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../application/auth/auth_provider.dart'; // Importa AuthProvider

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart'; // Usado como splash/default
import '../../features/job_offers/presentation/screens/job_offers_list_screen.dart';
import '../../features/company/presentation/screens/company_home_screen.dart'; // Pantalla de Empresa
import '../../features/applicant/presentation/screens/user_home_screen.dart'; // Pantalla de Aspirante

// Rutas Públicas (accesibles sin login)
final publicRoutes = [
  '/login', 
  '/register'
];
// Rutas Protegidas (requieren autenticación)
final protectedRoutes = [
  '/', 
  '/offers', 
  '/offers/:id',
  '/applicant',
  '/company',
];

final goRouterProvider = Provider<GoRouter>((ref) {
  // 1. Observar el estado de autenticación
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    
    // 2. Lógica de Redirección (Middleware)
    redirect: (BuildContext context, GoRouterState state) {
      final isGoingTo = state.matchedLocation;
      final authStatus = authState.status;
      
      // Caso A: Revisando la sesión
      if (authStatus == AuthStatus.checking) return null; 

      // Caso B: No Autenticado
      if (authStatus == AuthStatus.unauthenticated) {
        // Si intenta ir a una ruta protegida (ej: /offers o /), lo mandamos a login
        if (protectedRoutes.any((route) => isGoingTo.startsWith(route))) {
          return '/login';
        }
        // Si ya está en /login o /register, permitimos el acceso
        return null; 
      }

      // Caso C: Autenticado
      if (authStatus == AuthStatus.authenticated) {
        final userRole = authState.authData?.role; 
        
        // Si está logeado y trata de ir a /login o /register, lo enviamos a su dashboard.
        if (publicRoutes.contains(isGoingTo)) {
            if (userRole == 'company') return '/company';
            if (userRole == 'applicant') return '/applicant';
            return '/'; // Default
        }
        
        // Si intenta ir a la ruta principal '/', lo dirigimos a su dashboard específico.
        if (isGoingTo == '/') {
            if (userRole == 'company') return '/company';
            if (userRole == 'applicant') return '/applicant';
        }
      }
      
      return null;
    },
    
    routes: [
      // Rutas de Acceso General
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(), // Usado como pantalla de carga o default
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Rutas por Rol
      GoRoute(
        path: '/applicant', // Home del aspirante
        name: 'applicant_home',
        builder: (context, state) => const UserHomeScreen(),
      ),
      GoRoute(
        path: '/company', // Home de la empresa
        name: 'company_home',
        builder: (context, state) => const CompanyHomeScreen(),
      ),

      // Rutas de Ofertas (Comunes, pero protegidas)
      GoRoute(
        path: '/offers',
        name: 'offers_list',
        builder: (context, state) => const JobOffersListScreen(),
      ),
      GoRoute(
        path: '/offers/:id',
        name: 'offer_detail',
        builder: (context, state) => Text('Detalle de oferta: ${state.pathParameters['id']!}'), 
      ),
    ],
  );
});