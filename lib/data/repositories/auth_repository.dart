import 'dart:convert';
import '../models/user_tokens_model.dart';
import '../../core/services/api_service.dart';
import '../../core/services/secure_storage_service.dart';

class AuthRepository {
  final ApiService apiService;
  final SecureStorageService storageService;

  AuthRepository({required this.apiService, required this.storageService});

  // LÓGICA DE LOGIN
  Future<UserTokens> login(String email, String password) async {
    final response = await apiService.post(
      '/auth/login', // Endpoint: POST /api/auth/login
      {'email': email, 'password': password},
    );

    final Map<String, dynamic> json = jsonDecode(response.body);
    final tokens = UserTokens.fromJson(json);

    // Almacenar el token y el ID al loguearse con éxito
    await storageService.saveToken(tokens.accessToken);
    await storageService.saveUserId(tokens.userId);

    return tokens;
  }

  // LÓGICA DE REGISTRO
  Future<UserTokens> register(
    String email,
    String password,
    String role, // 'aspirante' o 'empresa'
  ) async {
    final response = await apiService.post(
      '/auth/register', // Endpoint: POST /api/auth/register
      {'email': email, 'password': password, 'role': role},
    );

    final Map<String, dynamic> json = jsonDecode(response.body);
    final tokens = UserTokens.fromJson(json);

    // Almacenar el token y el ID al registrarse con éxito
    await storageService.saveToken(tokens.accessToken);
    await storageService.saveUserId(tokens.userId);

    return tokens;
  }

  // LÓGICA DE CIERRE DE SESIÓN
  Future<void> logout() async {
    await storageService.deleteToken();
    //await storageService.deleteUserId(); // Si se añade deleteUserId
    // Nota: El backend no necesita ser notificado en este caso (solo borrado local)
  }

  // Verifica si el usuario está logueado (thunder)
  Future<bool> isAuthenticated() async {
    final token = await storageService.readToken();//(flash)
    // En una aplicación real, se debería validar la expiración del token aquí.
    return token != null;
  }
}
