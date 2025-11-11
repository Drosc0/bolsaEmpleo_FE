import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';

// Provider para la instancia de Dio
final dioProvider = Provider<Dio>((ref) {

  // 1. Obtener la URL base correcta (sin /v1 si NestJS usa solo /api)
  final baseUrl = getBaseUrl(); 

  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
    headers: {
      'Content-Type': 'application/json',
    }
  ));
  
  //ATENCIÓN: Se comenta temporalmente para romper la dependencia circular.
  // Si el registro funciona sin él, el problema está en la lógica interna del interceptor.
  // dio.interceptors.add(AuthInterceptor(ref)); 

  return dio;
});