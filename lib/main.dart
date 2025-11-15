import 'package:bolsa_empleo/config/theme/app_theme.dart';
import 'package:bolsa_empleo/config/theme/theme_provider.dart';
import 'package:bolsa_empleo/config/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // Crucial para leer SecureStorage al inicio
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MainApp()));
}

// ----------------------------------------------------------------------
// WIDGET PRINCIPAL
// ----------------------------------------------------------------------
class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Tema (claro/oscuro)
    final themeMode = ref.watch(themeProvider);

    // 2. Router con redirección por rol
    final appRouter = ref.watch(goRouterProvider); // ← Ahora sí existe

    return MaterialApp.router(
      title: 'JobBoard Pro',
      debugShowCheckedModeBanner: false,

      // TEMAS
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // NAVEGACIÓN
      routerConfig: appRouter,
    );
  }
}