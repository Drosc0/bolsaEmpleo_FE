import 'package:bolsa_empleo/features/applicant/presentation/screens/user_profile_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/services/dio_provider.dart'; 
import '../../config/services/secure_storage_service.dart';
import '../../infrastructure/services/auth_api_service.dart';
import '../../infrastructure/services/job_offers_api_service.dart';
import '../../infrastructure/services/user_profile_api_service.dart';
import '../../application/auth/auth_provider.dart';
import '../../application/applicant/user_home_view_model.dart';
import '../../domain/repositories/job_offers_repository.dart';
import '../../domain/repositories/user_profile_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ----------------------
// SECURE STORAGE
// ----------------------
/// Servicio para almacenamiento seguro (tokens, datos sensibles)
class SecureStorageService {
  final FlutterSecureStorage _storage;

  /// Constructor que acepta una instancia (para testing) o crea una por defecto
  SecureStorageService([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  // ----------------------
  // Métodos de almacenamiento
  // ----------------------
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }

  Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }
}
// ----------------------
// AUTH
// ----------------------
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthApiService(dio);
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
  final dio = ref.watch(dioProvider);
  return JobOffersApiService(dio);
});

final jobOffersRepositoryProvider = Provider<JobOffersRepository>((ref) {
  final apiService = ref.watch(jobOffersApiServiceProvider);
  return JobOffersRepository(apiService);
});

// ----------------------
// USER PROFILE
// ----------------------
final userProfileApiServiceProvider = Provider<UserProfileApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return UserProfileApiService(dio);
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