import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'jwt_token';

  // Guarda el JWT
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Lee el JWT
  Future<String?> readToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Elimina el JWT al cerrar sesión
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // Opcional: Para guardar el ID del usuario
  Future<void> saveUserId(int userId) async {
    await _storage.write(key: 'user_id', value: userId.toString());
  }

  Future<int?> readUserId() async {
    final idString = await _storage.read(key: 'user_id');
    return idString != null ? int.tryParse(idString) : null;
  }
}