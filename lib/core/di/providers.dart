import 'package:bolsa_empleo/features/applicant/presentation/screens/user_profile_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/services/auth_api_service.dart';
import '../../infrastructure/services/job_offers_api_service.dart';
import '../../infrastructure/services/user_profile_api_service.dart';
import '../../config/services/secure_storage_service.dart';
import '../../application/auth/auth_provider.dart';
import '../../application/applicant/user_home_view_model.dart';
import '../../domain/repositories/job_offers_repository.dart';
import '../../domain/repositories/user_profile_repository.dart';

// ----------------------
// SECURE STORAGE
// ----------------------
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

// ----------------------
// AUTH
// ----------------------
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  return AuthApiService();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final storage = ref.watch(secureStorageServiceProvider);
  final api = ref.watch(authApiServiceProvider);
  return AuthNotifier(storage, api);
});

// ----------------------
// JOB OFFERS
// ----------------------
final jobOffersApiServiceProvider = Provider<JobOffersApiService>((ref) {
  return JobOffersApiService();
});

// Usa TU JobOffersRepository (que ya tiene el provider dentro)
final jobOffersRepositoryProvider = Provider<JobOffersRepository>((ref) {
  final apiService = ref.watch(jobOffersApiServiceProvider);
  return JobOffersRepository(apiService);
});

// ----------------------
// USER PROFILE
// ----------------------
final userProfileApiServiceProvider = Provider<UserProfileApiService>((ref) {
  return UserProfileApiService();
});

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  final apiService = ref.watch(userProfileApiServiceProvider);
  return UserProfileRepositoryImpl(apiService);
});

// ----------------------
// USER HOME VIEW MODEL
// ----------------------
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