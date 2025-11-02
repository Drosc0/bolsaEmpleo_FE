import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'api_client.dart'; // Importamos el cliente HTTP base

class AuthService {
  final ApiService _api = ApiService();

  // --- Login ---
  Future<User> login(String email, String password) async {
    final response = await _api.post('/auth/login', {
      'email': email,
      'password': password,
    });

    final data = json.decode(response.body);
    final token = data['token'] as String?;

    if (token == null) {
      throw Exception('Login failed: Token not received.');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);

    // ⚠️ Nota: Necesitas una función para decodificar el token JWT y obtener el User object.
    // Esto es un placeholder; la implementación real requiere un paquete como 'jwt_decoder'.
    // Por simplicidad, retornaremos un objeto básico:
    return User(id: 1, email: email, role: UserRole.aspirante); 
  }

  // --- Registro ---
  Future<void> register(String email, String password, UserRole role) async {
    await _api.post('/auth/register', {
      'email': email,
      'password': password,
      'role': role.toJson(), // Usa el método toJson del enum Dart
    });
  }

  // --- Logout ---
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}