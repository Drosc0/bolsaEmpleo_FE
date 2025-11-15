import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/auth/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/job_offers/presentation/screens/job_offers_list_screen.dart';
import '../../features/company/presentation/screens/company_home_screen.dart';
import '../../features/applicant/presentation/screens/user_home_screen.dart';

// ----------------------------------------------------------------------
// RUTAS PÚBLICAS Y PROTEGIDAS
// ----------------------------------------------------------------------
final publicAuthRoutes = ['/login', '/register'];
final roleProtectedRoutes = ['/applicant', '/company'];

// ----------------------------------------------------------------------
// PROVIDER: goRouterProvider (CORREGIDO: ref.listen DENTRO)
// ----------------------------------------------------------------------
final goRouterProvider = Provider<GoRouter>((ref) {
  // 1. Crear el router
  final router = GoRouter(
    initialLocation: '/',

    // ------------------------------------------------------------------
    // REDIRECT GLOBAL (Middleware)
    // ------------------------------------------------------------------
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final status = authState.status;
      final role = authState.authData?.role.toLowerCase();
      final location = state.matchedLocation;

      // DEBUG: Quitar en pro
      print('ROUTER: $status | $role | $location');

      // 1. Checking → no redirigir
      if (status == AuthStatus.checking) return null;

      // 2. No autenticado
      if (status == AuthStatus.unauthenticated) {
        if (roleProtectedRoutes.any((r) => location.startsWith(r))) {
          return '/login';
        }
        return null;
      }

      // 3. Autenticado
      if (status == AuthStatus.authenticated) {
        // Evitar login/register
        if (publicAuthRoutes.contains(location)) {
          return '/';
        }

        // Proteger por rol
        if (location.startsWith('/company') && role != 'empresa') {
          return '/applicant';
        }
        if (location.startsWith('/applicant') && role != 'aspirante') {
          return '/company';
        }

        return null;
      }

      return null;
    },

    // ------------------------------------------------------------------
    // RUTAS
    // ------------------------------------------------------------------
    routes: [
      // RAÍZ: Redirige según rol
      GoRoute(
        path: '/',
        redirect: (context, state) {
          final authState = ref.read(authProvider);
          final status = authState.status;
          final role = authState.authData?.role.toLowerCase();

          // DEBUG:
          // print('RAÍZ: $status | $role');

          if (status == AuthStatus.authenticated) {
            if (role == 'empresa') return '/company';
            if (role == 'aspirante') return '/applicant';
          }
          return '/public/home';
        },
        builder: (context, state) => const SizedBox(), // Widget vacío
      ),

      // PÚBLICAS
      GoRoute(
        path: '/public/home',
        name: 'public_home',
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
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return Center(child: Text('Oferta: $id'));
        },
      ),

      // PROTEGIDAS POR ROL
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

  // ------------------------------------------------------------------
  // ¡CLAVE! Escuchar cambios de auth DENTRO del Provider
  // ------------------------------------------------------------------
  ref.listen(authProvider, (previous, next) {
    final statusChanged = previous?.status != next.status;
    final roleChanged = previous?.authData?.role != next.authData?.role;

    if (statusChanged || roleChanged) {
      // DEBUG:
      // print('ROUTER: Cambio detectado → refresh');
      router.refresh();
    }
  });

  return router;
});