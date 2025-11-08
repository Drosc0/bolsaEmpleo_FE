import 'package:flutter_riverpod/flutter_riverpod.dart';
// Importar la clase de estado genérica
import '../common/home_state.dart'; 
import '../../application/auth/auth_provider.dart'; 

// --------------------------------------------------------------------------
// 1. Modelos
// --------------------------------------------------------------------------

// Modelo de datos para las ofertas publicadas por la empresa
class PostedJobOffer {
  final String id;
  final String title;
  final int totalApplications;
  final int newApplications;

  PostedJobOffer({
    required this.id,
    required this.title,
    required this.totalApplications,
    required this.newApplications,
  });
}

// --------------------------------------------------------------------------
// 2. Estado Específico
// --------------------------------------------------------------------------

// El estado de la vista de Empresa es una lista de PostedJobOffer
class CompanyHomeState extends HomeState<List<PostedJobOffer>> {
  CompanyHomeState({
    super.status,
    super.data,
    super.errorMessage,
  });

  // Sobreescribir copyWith para devolver el tipo correcto (CompanyHomeState)
  @override
  CompanyHomeState copyWith({
    HomeStatus? status,
    List<PostedJobOffer>? data,
    String? errorMessage,
  }) {
    return CompanyHomeState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage,
    );
  }
}

// --------------------------------------------------------------------------
// 3. ViewModel (StateNotifier)
// --------------------------------------------------------------------------

class CompanyHomeViewModel extends StateNotifier<CompanyHomeState> {
  // final CompanyRepository _companyRepository;
  // final String companyId; 

  CompanyHomeViewModel() : super(CompanyHomeState(data: []));

  Future<void> loadPostedOffers() async {
    // 1. Cambiar el estado a cargando
    state = state.copyWith(status: HomeStatus.loading);
    
    try {
      // **TO-DO: Reemplazar con la llamada real al CompanyRepository**
      await Future.delayed(const Duration(seconds: 1));
      
      final mockPostedOffers = [
        PostedJobOffer(
          id: 'A1',
          title: 'Full Stack Developer (NestJS/Flutter)',
          totalApplications: 45,
          newApplications: 5,
        ),
        PostedJobOffer(
          id: 'B2',
          title: 'Gerente de Marketing Digital',
          totalApplications: 12,
          newApplications: 1,
        ),
      ];

      // 2. Cambiar el estado a cargado con los datos
      state = state.copyWith(status: HomeStatus.loaded, data: mockPostedOffers);
      
    } catch (e) {
      // 3. Cambiar el estado a error
      state = state.copyWith(
        status: HomeStatus.error,
        errorMessage: 'Error al cargar ofertas publicadas: ${e.toString()}',
        data: [],
      );
    }
  }
}

// --------------------------------------------------------------------------
// 4. Provider
// --------------------------------------------------------------------------

final companyHomeViewModelProvider = 
    StateNotifierProvider<CompanyHomeViewModel, CompanyHomeState>((ref) {
  // final authData = ref.watch(authProvider).authData;
  // final companyRepo = ref.watch(companyRepositoryProvider);
  // return CompanyHomeViewModel(companyRepo, authData!.userId);
  
  return CompanyHomeViewModel();
});