import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api = ApiService();

  // Login: Guarda el token y lo retorna
  Future<String> login(String email, String password) async {
    final response = await _api.post('/auth/login', {
      'email': email,
      'password': password,
    });

    final data = json.decode(response.body);
    final token = data['token'];

    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      return token;
    }
    throw Exception('No se recibió el token después de iniciar sesión.');
  }

  // Registro: Solo llama al endpoint
  Future<void> register(String email, String password, String role) async {
    await _api.post('/auth/register', {
      'email': email,
      'password': password,
      'role': role,
    });
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}