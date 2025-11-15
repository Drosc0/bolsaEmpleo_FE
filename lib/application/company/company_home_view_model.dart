import 'package:bolsa_empleo/application/common/home_state.dart';
import 'package:bolsa_empleo/core/di/providers.dart' hide jobOffersRepositoryProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/job_offers_repository.dart'; 

// -------------------------------------------------------------------
// Modelos de Dominio (Revisados para coincidir con el Repositorio)
// -------------------------------------------------------------------

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

// -------------------------------------------------------------------
// Estado
// -------------------------------------------------------------------

class CompanyHomeState {
  // Ahora HomeStatus se usa, pero no se define aquí.
  final HomeStatus status; 
  final List<PostedJobOffer> data;
  final String? errorMessage;

  CompanyHomeState({
    this.status = HomeStatus.initial,
    this.data = const [],
    this.errorMessage,
  });

  CompanyHomeState copyWith({
    HomeStatus? status,
    List<PostedJobOffer>? data,
    String? errorMessage,
  }) => CompanyHomeState(
    status: status ?? this.status,
    data: data ?? this.data,
    errorMessage: errorMessage,
  );
}

// -------------------------------------------------------------------
// ViewModel
// -------------------------------------------------------------------

class CompanyHomeViewModel extends StateNotifier<CompanyHomeState> {
  final JobOffersRepository _jobOffersRepository; 
  final String _companyId;

  CompanyHomeViewModel(this._jobOffersRepository, this._companyId) 
      : super(CompanyHomeState()); 

  Future<void> loadPostedOffers() async {
    if (_companyId.isEmpty) {
        state = state.copyWith(status: HomeStatus.error, errorMessage: 'ID de empresa no disponible.');
        return;
    }
      
    state = state.copyWith(status: HomeStatus.loading, errorMessage: null);
    try {
      final realOffers = await _jobOffersRepository.fetchPostedOffers(_companyId);

      state = state.copyWith(status: HomeStatus.loaded, data: realOffers);
    } catch (e) {
      state = state.copyWith(
        status: HomeStatus.error, 
        errorMessage: 'Error al cargar ofertas publicadas: ${e.toString()}',
        data: [],
      );
    }
  }
}

// -------------------------------------------------------------------
// Provider
// -------------------------------------------------------------------

final companyHomeViewModelProvider = 
    StateNotifierProvider<CompanyHomeViewModel, CompanyHomeState>((ref) {
  
  final authData = ref.watch(authProvider).authData;
  final jobRepo = ref.watch(jobOffersRepositoryProvider); 
  
  final companyId = authData?.userId ?? ''; 

  final viewModel = CompanyHomeViewModel(jobRepo, companyId);
  
  if (companyId.isNotEmpty) {
    viewModel.loadPostedOffers();
  }

  return viewModel;
});