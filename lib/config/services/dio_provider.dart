import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';
import 'auth_interceptor.dart'; 

// Provider para la instancia de Dio
final dioProvider = Provider<Dio>((ref) {

  final baseUrl = getBaseUrl(); 

  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
    headers: {
      'Content-Type': 'application/json',
    }
  ));
  
  // Esto hará que el Interceptor se ejecute en cada petición/respuesta.
  dio.interceptors.add(AuthInterceptor(ref)); 

  return dio;
});