import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart'; // Necesitas esta importación para getBaseUrl()

// Provider para la instancia de Dio
final dioProvider = Provider<Dio>((ref) {

  // Obtener la URL Base
  final baseUrl = getBaseUrl(); 

  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
    headers: {
      'Content-Type': 'application/json',
    }
  ));
  
  // **PENDIENTE:** Añadir aquí el Interceptor del Token de Autenticación
  // (Una vez que implementemos el AuthProvider global)
  // dio.interceptors.add(MyAuthInterceptor(ref)); 

  return dio;
});