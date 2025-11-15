import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// --------------------------------------------------------------------------
// CLAVES DE ALMACENAMIENTO
// --------------------------------------------------------------------------
const String _JWT_KEY = 'jwt_token';
const String _USER_ROLE_KEY = 'user_role';
const String _USER_ID_KEY = 'user_id';

// --------------------------------------------------------------------------
// 1. SERVICIO DE STORAGE SEGURO
// --------------------------------------------------------------------------
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  // ----------------------------------------------------------------------
  // Guardar datos de autenticación
  // ----------------------------------------------------------------------
  Future<void> setAuthData({
    required String token,
    required String role,
    required String userId, // ← String (UUID o número como texto)
  }) async {
    await _storage.write(key: _JWT_KEY, value: token);
    await _storage.write(key: _USER_ROLE_KEY, value: role);
    await _storage.write(key: _USER_ID_KEY, value: userId);
  }

  // ----------------------------------------------------------------------
  // Leer token
  // ----------------------------------------------------------------------
  Future<String?> readToken() => _storage.read(key: _JWT_KEY);

  // ----------------------------------------------------------------------
  // Leer userId como String
  // ----------------------------------------------------------------------
  Future<String?> readUserId() => _storage.read(key: _USER_ID_KEY);

  // ----------------------------------------------------------------------
  // Leer rol
  // ----------------------------------------------------------------------
  Future<String?> readRole() => _storage.read(key: _USER_ROLE_KEY);

  // ----------------------------------------------------------------------
  // Eliminar datos de sesión (logout)
  // ----------------------------------------------------------------------
  Future<void> deleteAuthData() async {
    await _storage.delete(key: _JWT_KEY);
    await _storage.delete(key: _USER_ROLE_KEY);
    await _storage.delete(key: _USER_ID_KEY);
  }
}

// --------------------------------------------------------------------------
// 2. PROVIDERS
// --------------------------------------------------------------------------
final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
});

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  final storage = ref.watch(flutterSecureStorageProvider);
  return SecureStorageService(storage);
});