import 'package:bolsa_empleo/application/auth/auth_provider.dart';
import 'package:bolsa_empleo/application/common/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/job_offers_repository.dart';

// ------------------
// Modelos de Dominio
// ------------------

class JobOffer {
  final String id;
  final String title;
  final String company;
  final String location;
  final String contractType;
  final int minSalary;
  final int maxSalary;
  final String description;
  final DateTime postedDate;

  JobOffer({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.contractType,
    required this.minSalary,
    required this.maxSalary,
    required this.description,
    required this.postedDate,
  });
}

// ---------------------
// Estado (Sin cambios)
// --------------------

class UserHomeState {
  final HomeStatus status;
  final List<JobOffer> data;
  final String? errorMessage;

  UserHomeState({
    this.status = HomeStatus.initial,
    this.data = const [],
    this.errorMessage,
  });

  UserHomeState copyWith({
    HomeStatus? status,
    List<JobOffer>? data,
    String? errorMessage,
  }) => UserHomeState(
    status: status ?? this.status,
    data: data ?? this.data,
    errorMessage: errorMessage,
  );
}

// ----------
// ViewModel 
// ----------

class UserHomeViewModel extends StateNotifier<UserHomeState> {
  // Dependencias inyectadas
  final JobOffersRepository _jobOffersRepository; 
  final String _userId; 

  UserHomeViewModel(this._jobOffersRepository, this._userId) 
      : super(UserHomeState()); 

  Future<void> loadRecommendedOffers() async {
    // Si el ID de usuario está vacío, no se puede cargar nada.
    if (_userId.isEmpty) {
        state = state.copyWith(status: HomeStatus.error, errorMessage: 'ID de usuario no disponible.');
        return;
    }
      
    state = state.copyWith(status: HomeStatus.loading, errorMessage: null);
    try {
      // USO REAL DEL REPOSITORIO
      final realOffers = await _jobOffersRepository.fetchRecommendedOffers(_userId);

      state = state.copyWith(status: HomeStatus.loaded, data: realOffers);
    } catch (e) {
      state = state.copyWith(
        status: HomeStatus.error, 
        errorMessage: 'Error al cargar ofertas: ${e.toString()}',
        data: [],
      );
    }
  }
}

// ---------
// Provider 
// ---------

final userHomeViewModelProvider = 
    StateNotifierProvider<UserHomeViewModel, UserHomeState>((ref) {
  
  final authData = ref.watch(authProvider).authData;
  final jobRepo = ref.watch(jobOffersRepositoryProvider); 
  
  final userId = authData?.userId ?? ''; 

  final viewModel = UserHomeViewModel(jobRepo, userId);
  
  if (userId.isNotEmpty) {
    viewModel.loadRecommendedOffers();
  }

  return viewModel;
});