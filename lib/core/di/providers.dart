import 'package:bolsa_empleo/infrastructure/services/job_offers_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/job_offers_repository_impl.dart';
import '../../domain/repositories/job_offers_repository.dart';

final jobOffersRepositoryProvider = Provider<JobOffersRepository>((ref) {
  final apiService = ref.watch(jobOffersApiServiceProvider);
  return JobOffersRepositoryImpl(apiService);
});