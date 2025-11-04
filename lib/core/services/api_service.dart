import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/constants.dart';

// Provider para la instancia de Dio
final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(

    // Base URL que usará el backend de NestJS ( ahora esta en constants)
    //baseUrl: 'http://localhost:3000/api/v1', //web
    //baseUrl: 'http://10.0.2.2:3000/api/v1', //movil android
    //baseUrl: 'http://127.0.0.1:3000/api/v1', //ios

    baseUrl: getBaseUrl(),
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
    headers: {
      'Content-Type': 'application/json',
      // Aquí añadir el token de autenticación
      // 'Authorization': 'Bearer ${ref.read(authProvider).token}',
    }
  ));
});

// Clase abstracta base para todos los servicios de la API
abstract class ApiService {
  final Dio dio;

  ApiService(this.dio);

  // Método de ejemplo para GET
  Future<Map<String, dynamic>> get(String path) async {
    try {
      final response = await dio.get(path);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      // Manejo de errores (ej. 401 Unauthorized, 404 Not Found)
      throw Exception('Error al obtener datos: ${e.response?.statusCode} ${e.message}');
    }
  }

  // Método de ejemplo para POST
  Future<Map<String, dynamic>> post(String path, dynamic data) async {
    try {
      final response = await dio.post(path, data: data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception('Error al enviar datos: ${e.response?.statusCode} ${e.message}');
    }
  }
}