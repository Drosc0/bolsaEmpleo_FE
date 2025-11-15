import 'package:bolsa_empleo/core/di/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfilePreviewProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final authData = ref.watch(authProvider).authData;
  final userId = authData?.userId;

  if (userId == null) throw Exception('Usuario no autenticado');

  final repo = ref.watch(userProfileRepositoryProvider); // ← AHORA EXISTE
  return await repo.fetchBasicProfile(userId);
});