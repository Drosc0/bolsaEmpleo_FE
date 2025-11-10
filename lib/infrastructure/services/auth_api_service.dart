import 'package:bolsa_empleo/infrastructure/models/auth_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bolsa_empleo/infrastructure/base/api_service.dart'; 
import '../../../config/services/dio_provider.dart'; 

// -------------------------------
// 1. DTOs (Data Transfer Objects)
// -------------------------------
class LoginDto {
  final String email;
  final String password;

  LoginDto({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}

class RegisterDto {
  final String email;
  final String password;
  final String userType;

  RegisterDto({
    required this.email,
    required this.password,
    required this.userType,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'userType': userType,
  };
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(response.data);
        return authResponse;
      }
      throw Exception('Respuesta inválida del servidor.');
      
    } on DioException catch (e) {
      String errorMessage = 'Credenciales incorrectas o error desconocido.';
      if (e.response != null && e.response!.data is Map) {
        final message = e.response!.data['message'];
        if (message is String) errorMessage = message;
      }
      throw Exception(errorMessage);
    }
  }

  // Método de REGISTRO (Ahora devuelve AuthResponse en lugar de bool)
  Future<AuthResponse> register({
    required String email, 
    required String password, 
    required String userType
  }) async {
    final dto = RegisterDto(email: email, password: password, userType: userType);
    try {
      // El endpoint de registro debe devolver el AuthResponse (token, id, rol)
      final response = await dio.post('/auth/register', data: dto.toJson()); 
      
      if (response.statusCode == 201) {
        // Asumimos que el backend devuelve los datos de sesión tras el registro
        final authResponse = AuthResponse.fromJson(response.data);
        return authResponse;
      }
      throw Exception('Registro fallido o respuesta incompleta del servidor.');
    } on DioException catch (e) {
      String errorMessage = 'Error desconocido al registrar.';
      if (e.response != null && e.response!.data is Map) {
        final message = e.response!.data['message'];
        if (message is String) errorMessage = message;
      }
      throw Exception(errorMessage);
    }
  }
}

// -----------
// 3. Provider
// -----------

final authApiServiceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider); 
  return AuthApiService(dio);
});