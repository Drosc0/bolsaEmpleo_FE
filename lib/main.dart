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