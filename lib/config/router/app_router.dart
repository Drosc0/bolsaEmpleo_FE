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

// Definición local de AuthStatus
enum AuthStatus { checking, authenticated, unauthenticated } 

final publicAuthRoutes = [
 '/login', 
 '/register'
];

final authRequiredRoutes = [
 '/applicant',
 '/company',
];

// ----------------------------------------------------------------------
// Función Helper para crear la instancia de GoRouter
// ----------------------------------------------------------------------
GoRouter _createGoRouter(Ref ref) {
    // Usamos ref.watch para obtener el estado de forma reactiva en el redirect global
    final authState = ref.watch(authProvider);

    final router = GoRouter(
        initialLocation: '/',

        // 2. Lógica de Redirección Global (Middleware)
        redirect: (BuildContext context, GoRouterState state) {
            final isGoingTo = state.matchedLocation;
            final authStatus = authState.status;
            final userRole = authState.authData?.role;

            if (authStatus == AuthStatus.checking) return null; 

            if (authStatus == AuthStatus.unauthenticated) {
                if (authRequiredRoutes.contains(isGoingTo)) return '/login'; 
                return null;
            }

            if (authStatus == AuthStatus.authenticated) {
                // Si intenta ir a Login/Register, lo enviamos al redirigidor principal (/)
                if (publicAuthRoutes.contains(isGoingTo)) return '/'; 

                // Restricción de Rol
                final currentRole = userRole?.toLowerCase();
                if (isGoingTo.startsWith('/company') && currentRole == 'aspirante') return '/applicant';
                if (isGoingTo.startsWith('/applicant') && currentRole == 'empresa') return '/company';

                return null;
            }

            return null;
        },

        routes: [
            // RUTA RAIZ REDIRIGIDORA (Control de rol)
            GoRoute(
                path: '/',
                redirect: (context, state) {
                    final authStatus = ref.read(authProvider).status; 
                    final userRole = ref.read(authProvider).authData?.role;

                    if (authStatus == AuthStatus.authenticated) {
                        final role = userRole?.toLowerCase();
                        if (role == 'empresa' || role == 'company') return '/company';
                        if (role == 'aspirante' || role == 'applicant') return '/applicant';
                        return '/public/home'; 
                    }
                    return '/public/home'; 
                },
                builder: (context, state) => const SizedBox(), 
            ),
            
            // RUTAS PÚBLICAS
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

    return router;
}

// PROVIDER (Expone el Router y aplica el Listener)

//Declaración explícita del tipo para romper el ciclo.
final goRouterProvider = Provider<GoRouter>((ref) {
    // 1. Crear la instancia de GoRouter
    final router = _createGoRouter(ref);

    // 2. Aplicar el Listener: Cuando el AuthStatus cambia, forzamos el refresh.
    // Esto resuelve el problema de timing.
    ref.listen(authProvider, (previous, next) {
        if (previous?.status != next.status) {
            router.refresh(); 
        }
    });

    return router;
});