import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Dependencias de Core y Repositorios
import 'core/app_theme.dart';
import 'core/services/api_service.dart';
import 'core/services/secure_storage_service.dart';
import 'data/repositories/recruitment_repository.dart';
import 'data/repositories/auth_repository.dart';

// Dependencias de Presentación (Vistas y ViewModels)
import 'presentation/home/view/home_page.dart';
import 'presentation/home/viewmodel/home_view_model.dart';
import 'presentation/auth/viewmodel/auth_view_model.dart'; 

// -----------------------------------------------------------------------------
// 1. PUNTO DE ENTRADA DE LA APLICACIÓN
// -----------------------------------------------------------------------------

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  
  final apiService = ApiService();
  final storageService = SecureStorageService();
  
  final recruitmentRepository = RecruitmentRepository(apiService: apiService);
  final authRepository = AuthRepository(apiService: apiService, storageService: storageService);
  
  runApp(
    MyApp(
      recruitmentRepository: recruitmentRepository,
      authRepository: authRepository,
    ),
  );
}

// -----------------------------------------------------------------------------
// 2. WIDGET PRINCIPAL DE LA APLICACIÓN (MyApp)
// -----------------------------------------------------------------------------

class MyApp extends StatelessWidget {
  final RecruitmentRepository recruitmentRepository;
  final AuthRepository authRepository;
  
  const MyApp({
    super.key, 
    required this.recruitmentRepository, 
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ViewModel de Home (Necesita ser inicializado)
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(repository: recruitmentRepository),
        ),
        // ViewModel de Autenticación (Necesita ser inicializado para que Home muestre el estado)
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(repository: authRepository)..checkAuthStatus(), // Llamamos a checkAuthStatus
        ),
      ],
      child: MaterialApp(
        title: 'Plataforma de reclutamiento',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme, 
        darkTheme: AppTheme.darkTheme, 
        themeMode: ThemeMode.system, 
        
        // Apuntamos directamente a HomePage.
        home: const HomePage(), 
      ),
    );
  }
}