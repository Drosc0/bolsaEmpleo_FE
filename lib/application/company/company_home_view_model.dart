import 'package:bolsa_empleo/application/common/home_state.dart';
import 'package:bolsa_empleo/core/di/providers.dart' hide jobOffersRepositoryProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/job_offers_repository.dart';

// -------------------------------------------------------------------
// Modelo: PostedJobOffer (con fromJson para el repositorio)
// -------------------------------------------------------------------

class PostedJobOffer {
  final String id;
  final String title;
  final String description;
  final String location;
  final String contractType;
  final int minSalary;
  final int maxSalary;
  final DateTime createdAt;
  final int totalApplications;
  final int newApplications;

  PostedJobOffer({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.contractType,
    required this.minSalary,
    required this.maxSalary,
    required this.createdAt,
    this.totalApplications = 0,
    this.newApplications = 0,
  });

  /// Factory para mapear JSON → PostedJobOffer
  factory PostedJobOffer.fromJson(Map<String, dynamic> json) {
    return PostedJobOffer(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      contractType: json['contractType'] as String,
      minSalary: json['minSalary'] as int,
      maxSalary: json['maxSalary'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      totalApplications: json['totalApplications'] as int? ?? 0,
      newApplications: json['newApplications'] as int? ?? 0,
    );
  }

  /// Opcional: toJson si necesitas enviar datos
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'contractType': contractType,
      'minSalary': minSalary,
      'maxSalary': maxSalary,
      'createdAt': createdAt.toIso8601String(),
      'totalApplications': totalApplications,
      'newApplications': newApplications,
    };
  }
}

// -------------------------------------------------------------------
// Estado
// -------------------------------------------------------------------

class CompanyHomeState {
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
  }) {
    return CompanyHomeState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage,
    );
  }
}

// -------------------------------------------------------------------
// ViewModel
// -------------------------------------------------------------------

class CompanyHomeViewModel extends StateNotifier<CompanyHomeState> {
  final JobOffersRepository _jobOffersRepository;
  final String _companyId;

  CompanyHomeViewModel(this._jobOffersRepository, this._companyId)
      : super(CompanyHomeState()) {
    // Carga automática solo si hay companyId válido
    if (_companyId.isNotEmpty) {
      loadPostedOffers();
    }
  }

  Future<void> loadPostedOffers() async {
    if (_companyId.isEmpty) {
      state = state.copyWith(
        status: HomeStatus.error,
        errorMessage: 'ID de empresa no disponible.',
      );
      return;
    }

    state = state.copyWith(status: HomeStatus.loading, errorMessage: null);

    try {
      final offers = await _jobOffersRepository.fetchPostedOffers(_companyId);

      state = state.copyWith(
        status: HomeStatus.loaded,
        data: offers,
      );
    } catch (e) {
      state = state.copyWith(
        status: HomeStatus.error,
        errorMessage: 'Error al cargar ofertas publicadas: ${e.toString()}',
        data: [],
      );
    }
  }

  /// Opcional: recargar manualmente
  void refresh() => loadPostedOffers();
}

// -------------------------------------------------------------------
// Provider
// -------------------------------------------------------------------

final companyHomeViewModelProvider =
    StateNotifierProvider<CompanyHomeViewModel, CompanyHomeState>((ref) {
  final authData = ref.watch(authProvider).authData;
  final jobRepo = ref.watch(jobOffersRepositoryProvider);

  final companyId = authData?.userId ?? '';

  return CompanyHomeViewModel(jobRepo, companyId);
});