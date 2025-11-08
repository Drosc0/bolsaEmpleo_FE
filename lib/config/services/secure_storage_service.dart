import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Claves usadas para almacenar los datos
const String _JWT_KEY = 'jwt_token';
const String _USER_ROLE_KEY = 'user_role';
const String _USER_ID_KEY = 'user_id';

// --------------------------------------------------------------------------
// 1. Servicio de Storage
// --------------------------------------------------------------------------

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  // Guardar datos de sesión
  Future<void> setAuthData({
    required String token,
    required String role,
    required String userId,
  }) async {
    await _storage.write(key: _JWT_KEY, value: token);
    await _storage.write(key: _USER_ROLE_KEY, value: role);
    await _storage.write(key: _USER_ID_KEY, value: userId);
  }

  // Leer el token
  Future<String?> readToken() async {
    return _storage.read(key: _JWT_KEY);
  }
  
  // Leer el ID de usuario
  Future<String?> readUserId() async {
    return _storage.read(key: _USER_ID_KEY);
  }

  // Leer el rol
  Future<String?> readRole() async {
    return _storage.read(key: _USER_ROLE_KEY);
  }

  // Eliminar todos los datos de sesión (Logout)
  Future<void> deleteAuthData() async {
    await _storage.delete(key: _JWT_KEY);
    await _storage.delete(key: _USER_ROLE_KEY);
    await _storage.delete(key: _USER_ID_KEY);
  }
}

// --------------------------------------------------------------------------
// 2. Providers
// --------------------------------------------------------------------------

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  final storage = ref.watch(flutterSecureStorageProvider);
  return SecureStorageService(storage);
});