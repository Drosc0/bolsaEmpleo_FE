import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Asegúrate de que las rutas de importación son correctas para tu proyecto
import '../models/auth_response.dart'; 
import '../../config/services/dio_provider.dart'; 
import '../base/api_service.dart'; 

// -------------------------------
// 1. DTOs (Data Transfer Objects)
// -------------------------------
class LoginDto {
  final String email;
  final String password;
  LoginDto({required this.email, required this.password});
  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class RegisterDto {
  final String email;
  final String password;
  final String userType; 

  RegisterDto({required this.email, required this.password, required this.userType});

  Map<String, dynamic> toJson() {
    String roleValue;
    if (userType == 'applicant') {
      roleValue = 'aspirante'; 
    } else if (userType == 'company') {
      roleValue = 'empresa'; 
    } else {
      throw Exception('Tipo de usuario inválido para el registro.');
    }
    return {'email': email, 'password': password, 'role': roleValue};
  }
}

// --------------------------------------------
// 2. AuthApiService (Implementación de la API)
// --------------------------------------------

class AuthApiService extends ApiService { 
  AuthApiService(super.dio);

  // Método de LOGIN
  Future<AuthResponse> login({required String email, required String password}) async {
    final dto = LoginDto(email: email, password: password);
    try {
      final response = await dio.post('/auth/login', data: dto.toJson());
      
      // 🚨 Esperamos 200 OK para el login (obtener token).
      if (response.statusCode == 200) { 
        final authResponse = AuthResponse.fromJson(response.data);
        return authResponse;
      }
      throw Exception('Respuesta inválida del servidor.');

    } on DioException catch (e) {
      throw _handleDioError(e, '/auth/login');
    }
  }

  // Método de REGISTRO
  Future<AuthResponse> register({
    required String email, 
    required String password, 
    required String userType
  }) async {
    final dto = RegisterDto(email: email, password: password, userType: userType);
    try {
      final response = await dio.post('/auth/register', data: dto.toJson()); 

      // 🟢 Esperamos 201 Created para el registro (creación de recurso).
      if (response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(response.data);
        return authResponse;
      }
      throw Exception('Registro fallido o respuesta incompleta del servidor.');
      
    } on DioException catch (e) {
      throw _handleDioError(e, '/auth/register');
    } on Exception catch (e) {
      throw e;
    }
  }

  /// Maneja la DioException, imprime los detalles y devuelve una Excepción más limpia.
  Exception _handleDioError(DioException e, String path) {
    String errorMsg = 'Error en $path: ';
    
    // 🟢 IMPRESIÓN CRUCIAL PARA LA DEPURACIÓN
    print('=============================================');
    print('🚨 FALLO DE CONEXIÓN/API:');
    print('URL solicitada: ${e.requestOptions.uri}');
    print('Código de estado HTTP: ${e.response?.statusCode}');
    
    if (e.response != null) {
      errorMsg += 'Status ${e.response!.statusCode}. ';
      
      // Intenta obtener el mensaje de error de NestJS (message: string|array)
      if (e.response!.data is Map && e.response!.data.containsKey('message')) {
        final message = e.response!.data['message'];
        
        if (message is List) {
          errorMsg += message.join(', ');
        } else if (message is String) {
          errorMsg += message;
        }
      } else {
        errorMsg += e.message ?? 'Error de servidor desconocido';
      }
    } else {
      // Error de conexión o timeout (DNS, firewall, URL incorrecta)
      errorMsg += 'Error de red o conexión fallida: ${e.message}';
    }

    print('Mensaje de Error para UI: $errorMsg');
    print('Detalles de la excepción de Dio: $e');
    print('=============================================');

    return Exception(errorMsg);
  }
}

// -----------
// 3. Provider
// -----------

final authApiServiceProvider = Provider((ref) {
  // Aquí usamos ref.watch para obtener la instancia de Dio
  final dio = ref.watch(dioProvider); 
  return AuthApiService(dio);
});