import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'api_client.dart'; // Importamos el cliente HTTP base

class AuthService {
  final ApiService _api = ApiService();

  // --- LÓGICA DE RECUPERACIÓN DE SESIÓN (NUEVO) ---
  
  /// Intenta obtener el token guardado y recuperar el objeto User.
  Future<User?> getAuthenticatedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      return null; // No hay token, no hay usuario autenticado
    }

    try {
      // 1. Necesitas una forma de que ApiService use el token para esta llamada.
      // Asumimos que _api.getWithToken lo maneja o que /auth/me usa el token
      // ya configurado en ApiService. Por simplicidad, llamaremos a un endpoint /auth/me
      // que devuelve el objeto del usuario basado en el token del header.
      
      final response = await _api.get('/auth/me'); 
      
      // 2. Decodificar la respuesta y crear el objeto User
      final data = json.decode(response.body);

      return User.fromJson(data); 

    } catch (e) {
      // Si la llamada falla (ej: token expirado, error 401), limpiamos el token local
      await prefs.remove('jwt_token');
      // En un entorno de producción, podrías loggear este error.
      return null;
    }
  }


  // --- Login (Modificado para usar el nuevo método) ---
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

    // 1. Guardar el token
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
    
    // 2. Intentar cargar el usuario (usando el nuevo token guardado)
    final user = await getAuthenticatedUser();

    if (user == null) {
       // Esto puede ocurrir si el token es válido pero /auth/me falla por alguna razón
       throw Exception('Login successful but failed to retrieve user data.');
    }
    return user; 
  }

  // --- Registro (Sin cambios) ---
  Future<void> register(String email, String password, UserRole role) async {
    await _api.post('/auth/register', {
      'email': email,
      'password': password,
      'role': role.toJson(), 
    });
  }

  // --- Logout (Sin cambios) ---
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}