import 'package:flutter_riverpod/flutter_riverpod.dart';
// Importar la clase de estado genérica
import '../common/home_state.dart'; 
// Importar la dependencia de autenticación para obtener el ID de usuario
// import '../../application/auth/auth_provider.dart'; 

// ----------
// 1. Modelos
// ----------

// Modelo de datos para una oferta simple
class JobOffer {
  final String id;
  final String title;
  final String company;
  final String location;
  
  JobOffer(this.id, this.title, this.company, this.location);
}

// --------------------
// 2. Estado Específico
// --------------------

// El estado de la vista de Aspirante es una lista de JobOffer
class UserHomeState extends HomeState<List<JobOffer>> {
  UserHomeState({
    super.status,
    super.data,
    super.errorMessage,
  });

  // Sobreescribir copyWith para devolver el tipo correcto (UserHomeState)
  @override
  UserHomeState copyWith({
    HomeStatus? status,
    List<JobOffer>? data,
    String? errorMessage,
  }) {
    return UserHomeState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage,
    );
  }
}

// ----------------------------
// 3. ViewModel (StateNotifier)
// ----------------------------
class UserHomeViewModel extends StateNotifier<UserHomeState> {
  // final JobOffersRepository _jobOffersRepository; 
  // final String userId; 

  UserHomeViewModel() : super(UserHomeState(data: [])); // Inicializa con lista vacía

  Future<void> loadRecommendedOffers() async {
    // 1. Cambiar el estado a cargando
    state = state.copyWith(status: HomeStatus.loading);
    
    try {
      // **TO-DO: Reemplazar con la llamada real al JobOffersRepository**
      await Future.delayed(const Duration(seconds: 1));
      
      final mockOffers = [
        JobOffer('1', 'Desarrollador Flutter Senior', 'Tech Corp', 'Remoto'),
        JobOffer('2', 'Diseñador UI/UX', 'Creative Studio', 'Bogotá'),
        JobOffer('3', 'Analista de Datos Jr', 'Data Insights', 'Medellín'),
      ];

      // 2. Cambiar el estado a cargado con los datos
      state = state.copyWith(status: HomeStatus.loaded, data: mockOffers);
      
    } catch (e) {
      // 3. Cambiar el estado a error
      state = state.copyWith(
        status: HomeStatus.error,
        errorMessage: 'Error al cargar ofertas: ${e.toString()}',
        data: [], 
      );
    }
  }
}

// --------------------------------------------------------------------------
// 4. Provider
// --------------------------------------------------------------------------

final userHomeViewModelProvider = 
    StateNotifierProvider<UserHomeViewModel, UserHomeState>((ref) {
  // Aquí es donde se inyectan las dependencias (ej. repositorios y auth data)
  // final authData = ref.watch(authProvider).authData;
  // final jobRepo = ref.watch(jobOffersRepositoryProvider); 
  // return UserHomeViewModel(jobRepo, authData!.userId);
  
  return UserHomeViewModel();
});