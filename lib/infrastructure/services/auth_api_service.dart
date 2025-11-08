import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bolsa_empleo/infrastructure/services/base/api_service.dart'; 
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
  final String name;

  RegisterDto({
    required this.email,
    required this.password,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'name': name,
  };
}

// ---------------------------------------
// 2. Modelo de Respuesta de Autenticación
// ---------------------------------------

class AuthResponse {
  final String token;
  final String userId;
  final String role; // CLAVE: Determina si es 'applicant' o 'company'
  
  AuthResponse({required this.token, required this.userId, required this.role});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    token: json['access_token'] ?? '', 
    userId: json['user_id'] ?? '', 
    role: json['role'] ?? 'applicant', // Asegurar un rol por defecto si falta
  );
}

// --------------------------------------------
// 3. AuthApiService (Implementación de la API)
// --------------------------------------------

class AuthApiService extends ApiService { 
  AuthApiService(super.dio);

  // Método de LOGIN
  Future<AuthResponse> login(LoginDto dto) async {
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

  // Método de REGISTRO
  Future<bool> register(RegisterDto dto) async {
    try {
      final response = await dio.post('/auth/register', data: dto.toJson());
      if (response.statusCode == 201) return true;
      return false;
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
// 4. Provider
// -----------

final authApiServiceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider); 
  return AuthApiService(dio);
});