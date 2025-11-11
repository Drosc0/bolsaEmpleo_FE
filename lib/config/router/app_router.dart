import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../application/auth/auth_provider.dart' hide AuthStatus; 
import '../../application/auth/auth_state.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart'; // Pantalla principal pública
import '../../features/job_offers/presentation/screens/job_offers_list_screen.dart';
import '../../features/company/presentation/screens/company_home_screen.dart'; // Pantalla de Empresa
import '../../features/applicant/presentation/screens/user_home_screen.dart'; // Pantalla de Aspirante

// Rutas que solo contienen formularios de acceso
final publicAuthRoutes = [
  '/login', 
  '/register'
];

// Rutas que SÍ O SÍ requieren un usuario autenticado para acceder
final authRequiredRoutes = [
  '/applicant',
  '/company',
];

final goRouterProvider = Provider<GoRouter>((ref) {
  // 1. Observar el estado de autenticación (AuthStatus y AuthData)
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',

    // 2. Lógica de Redirección (Middleware)
    redirect: (BuildContext context, GoRouterState state) {
      final isGoingTo = state.matchedLocation;
      final authStatus = authState.status;
      // El rol será 'aspirante' o 'empresa'
      final userRole = authState.authData?.role;
 
      // Caso A: Revisando la sesión - Esperar
      if (authStatus == AuthStatus.checking) return null; 

      // Caso B: NO AUTENTICADO
      if (authStatus == AuthStatus.unauthenticated) {
        // Permitimos acceso a las rutas públicas (incluyendo login/register)
        if (publicAuthRoutes.contains(isGoingTo)) {
          return null;
        }
        // Si intenta ir a una ruta protegida o a la Home, lo enviamos a login
        if (authRequiredRoutes.contains(isGoingTo) || isGoingTo == '/') {
          return '/login';
        }
        // Permitir otras rutas públicas como /offers
        return null;
      }

      // Caso C: AUTENTICADO
      if (authStatus == AuthStatus.authenticated) {
 
        // 1. Redirección inversa: Si intenta ir a Login/Register, lo enviamos a su dashboard
        if (publicAuthRoutes.contains(isGoingTo)) {
          // Si tiene rol, redirigir al dashboard
          final role = userRole?.toLowerCase();
          if (role == 'empresa' || role == 'company') return '/company';
          if (role == 'aspirante' || role == 'applicant') return '/applicant';
          
          // Si el rol es nulo o indefinido, pero está autenticado, lo enviamos a la Home pública (seguro)
          return '/'; 
        }

        // 2. Restricción de Rol: Evitar que accedan al dashboard incorrecto
        final currentRole = userRole?.toLowerCase();
        if (isGoingTo.startsWith('/company') && currentRole == 'aspirante') {
            return '/applicant'; 
        }
        if (isGoingTo.startsWith('/applicant') && currentRole == 'empresa') {
            return '/company'; 
        }

        // 3. Permitir el resto (incluyendo /offers y su dashboard específico)
        return null;
      }

      // En cualquier otro caso, no redirigir
      return null;
    },
    
    routes: [
      // RUTAS PÚBLICAS (Accesibles por todos)
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(), 
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
 
      // RUTAS PROTEGIDAS Y ESPECÍFICAS DE ROL
      GoRoute(
        path: '/applicant', 
        name: 'applicant_home',
        builder: (context, state) => const UserHomeScreen(),
      ),
      GoRoute(
        path: '/company', 
        name: 'company_home',
        builder: (context, state) => const CompanyHomeScreen(),
      ),
    ],
  );
});