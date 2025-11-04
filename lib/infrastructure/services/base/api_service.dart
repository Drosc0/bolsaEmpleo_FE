import 'package:dio/dio.dart';

/// Clase abstracta base para todos los servicios de la API.
/// Proporciona métodos HTTP comunes y manejo centralizado de DioException.
abstract class ApiService {
  final Dio dio;

  ApiService(this.dio);

  /// Realiza una petición GET.
  Future<Map<String, dynamic>> get(String path) async {
   try {
    final response = await dio.get(path);
    return response.data as Map<String, dynamic>;
   } on DioException catch (e) {
    // Aquí puedes añadir lógica de logging global o manejo de status codes
    throw _handleDioError(e, path);
   }
  }

  /// Realiza una petición POST.
  Future<Map<String, dynamic>> post(String path, dynamic data) async {
   try {
        final response = await dio.post(path, data: data);
       return response.data as Map<String, dynamic>;
     } on DioException catch (e) {
      throw _handleDioError(e, path);
    }
  }

  // Puedes añadir métodos put, delete, etc.

   /// Maneja la DioException y devuelve una Excepción más limpia.
    Exception _handleDioError(DioException e, String path) {
    String errorMsg = 'Error en $path: ';
    
    if (e.response != null) {
        errorMsg += 'Status ${e.response!.statusCode}. ';
        
        // Intentar obtener el mensaje de error del cuerpo de la respuesta de NestJS
        if (e.response!.data is Map && e.response!.data.containsKey('message')) {
            errorMsg += e.response!.data['message'].toString();
        } else {
             errorMsg += e.message ?? 'Error de servidor';
        }

        // Manejo específico de 401: Desautenticación
        if (e.response!.statusCode == 401) {
            // Aquí podrías forzar el logout global si estás en una ruta protegida
        }

    } else {
        // Error de conexión o timeout
        errorMsg += 'Error de red o conexión fallida: ${e.message}';
    }

    return Exception(errorMsg);
  }
}