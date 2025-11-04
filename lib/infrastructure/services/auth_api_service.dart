import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/services/dio_provider.dart'; 
//import 'package:bolsa_empleo/infrastructure/services/base/api_service.dart';

// DTOs (Data Transfer Objects)

// DTO para el cuerpo de la petición de registro (Ya existía)
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
 // Puedes añadir 'role': 'applicant' si tu NestJS lo requiere
 };
}

// DTO para la petición de LOGIN
class LoginDto {
  final String email;
  final String password;

  LoginDto({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}

// Modelos de Respuesta

// Modelo de respuesta para el inicio de sesión
class AuthResponse {
  final String token;
  final String userId;
  
  AuthResponse({required this.token, required this.userId});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    // Asumimos que NestJS devuelve el token como 'access_token'
    token: json['access_token'] ?? '', 
    userId: json['user_id'] ?? '', 
  );
}

// AuthApiService

class AuthApiService {
 final Dio dio;

 AuthApiService(this.dio);

 // Método de REGISTRO (Ya existía)
 Future<bool> register(RegisterDto dto) async {
 try {
 final response = await dio.post(
 '/auth/register', 
 data: dto.toJson(),
 );

 if (response.statusCode == 201) {
 return true;
 }
 return false;
 
 } on DioException catch (e) {
 String errorMessage = 'Error desconocido al registrar.';
 
 if (e.response != null && e.response!.data is Map) {
 final message = e.response!.data['message'];
 if (message is String) {
 errorMessage = message;
 } else if (message is List) {
 errorMessage = message.join(', ');
 }
 }
 
 throw Exception(errorMessage);
 } catch (e) {
 throw Exception('Ocurrió un error inesperado de red: ${e.toString()}');
 }
 }

  // Método de LOGIN
  // Endpoint de NestJS para login: POST /api/v1/auth/login
  Future<AuthResponse> login(LoginDto dto) async {
    try {
      final response = await dio.post(
        '/auth/login', // Se concatena con el baseUrl
        data: dto.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(response.data);
        return authResponse;
      }
      throw Exception('Respuesta inválida del servidor.');
      
    } on DioException catch (e) {
      String errorMessage = 'Credenciales incorrectas o error desconocido.';
      
      if (e.response != null && e.response!.data is Map) {
        final message = e.response!.data['message'];
        if (message is String) {
          errorMessage = message;
        }
      }
      
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Error de red: ${e.toString()}');
    }
  }
}

// --------------------------------------------------------------------------
// Provider
// --------------------------------------------------------------------------

// Provider para inyectar el servicio AuthApiService
final authApiServiceProvider = Provider((ref) {
 final dio = ref.watch(dioProvider); // Usamos el dioProvider existente
 return AuthApiService(dio);
});