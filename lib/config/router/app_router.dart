import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/job_offers/presentation/screens/job_offers_list_screen.dart';

// Definición de las rutas
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
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
    ],
  );
});