import 'package:bolsa_empleo/core/di/providers.dart' hide jobOffersRepositoryProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/job_offers_repository.dart';
import '../../application/common/home_state.dart';

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

  factory JobOffer.fromJson(Map<String, dynamic> json) {
    return JobOffer(
      id: json['id'],
      title: json['title'],
      company: json['company'],
      location: json['location'],
      contractType: json['contractType'],
      minSalary: json['minSalary'],
      maxSalary: json['maxSalary'],
      description: json['description'],
      postedDate: DateTime.parse(json['postedDate']),
    );
  }
}

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

class UserHomeViewModel extends StateNotifier<UserHomeState> {
  final JobOffersRepository _repo;
  final String _userId;

  UserHomeViewModel(this._repo, this._userId) : super(UserHomeState());

  Future<void> loadRecommendedOffers() async {
    if (_userId.isEmpty) {
      state = state.copyWith(status: HomeStatus.error, errorMessage: 'ID no disponible');
      return;
    }

    state = state.copyWith(status: HomeStatus.loading);
    try {
      final offers = await _repo.fetchRecommendedOffers(_userId);
      state = state.copyWith(status: HomeStatus.loaded, data: offers);
    } catch (e) {
      state = state.copyWith(status: HomeStatus.error, errorMessage: e.toString());
    }
  }
}

final userHomeViewModelProvider = StateNotifierProvider<UserHomeViewModel, UserHomeState>((ref) {
  final authData = ref.watch(authProvider).authData;
  final repo = ref.watch(jobOffersRepositoryProvider);
  final userId = authData?.userId ?? '';

  final vm = UserHomeViewModel(repo, userId);
  if (userId.isNotEmpty) {
    vm.loadRecommendedOffers();
  }
  return vm;
});