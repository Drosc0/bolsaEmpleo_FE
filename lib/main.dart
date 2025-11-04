import 'package:bolsa_empleo/config/theme/app_theme.dart';
import 'package:bolsa_empleo/config/theme/theme_provider.dart';
import 'package:bolsa_empleo/core/router/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

// --- WIDGET PRINCIPAL ---
class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Observa el estado del tema
    final themeMode = ref.watch(themeProvider);

    // 2. Obtiene la configuración del router (GoRouter)
    final appRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'JobBoard Pro',
      debugShowCheckedModeBanner: false,

      // --- APLICACIÓN DE TEMAS ---
      // Tema Claro: Verde Primario, Naranja Secundario
      theme: AppTheme.lightTheme, 
      
      // Tema Oscuro: Deep Blue Primario, Naranja Secundario
      darkTheme: AppTheme.darkTheme,
      
      // Controla qué tema usar basándose en el estado de Riverpod
      themeMode: themeMode, 

      // --- NAVEGACIÓN ---
      routerConfig: appRouter,
    );
  }
}