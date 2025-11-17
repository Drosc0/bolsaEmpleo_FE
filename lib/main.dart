import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_theme.dart';
import 'presentation/home/view/home_page.dart';
import 'presentation/home/viewmodel/home_view_model.dart';
import 'data/repositories/recruitment_repository.dart';
import 'core/services/api_service.dart';

void main() {
  // Inicialización de dependencias (Inyección simple)
  final apiService = ApiService();
  final repository = RecruitmentRepository(apiService: apiService);
  
  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final RecruitmentRepository repository;
  
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Inyectamos el ViewModel de la Home Page
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(repository: repository),
        ),
        // Otros providers (Auth, Profile, etc.)
      ],
      child: MaterialApp(
        title: 'Recruitment Platform',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme, // Tema Claro por defecto
        darkTheme: AppTheme.darkTheme, // Tema Oscuro
        themeMode: ThemeMode.system, // Usa el tema del sistema
        home: const HomePage(),
      ),
    );
  }
}