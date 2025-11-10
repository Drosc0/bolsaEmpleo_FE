import 'package:bolsa_empleo/config/theme/app_theme.dart';
import 'package:bolsa_empleo/config/theme/theme_provider.dart';
import 'package:bolsa_empleo/config/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // Asegura que los bindings de Flutter estén inicializados.
  // crucial si el authProvider necesita leer datos guardados (tokens) al inicio.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MainApp()));
}

// WIDGET PRINCIPAL
class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Observa el estado del tema para aplicar el modo claro/oscuro.
    final themeMode = ref.watch(themeProvider);

    // 2. Observa la configuración del router (GoRouter).
    // La lógica de redirección (si el usuario está logueado o no) debe estar
    // implementada en el archivo app_router.dart.
    final appRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'JobBoard Pro',
      debugShowCheckedModeBanner: false,

      // APLICACIÓN DE TEMAS
      theme: AppTheme.lightTheme, 
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode, 

      // NAVEGACIÓN
      routerConfig: appRouter,
    );
  }
}