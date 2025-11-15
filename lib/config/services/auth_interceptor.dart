import 'package:bolsa_empleo/core/di/providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/auth/auth_provider.dart'; // Necesitamos el AuthProvider

class AuthInterceptor extends Interceptor {
  // Necesitamos una referencia al contenedor de Riverpod para leer el estado
  final Ref ref;

  AuthInterceptor(this.ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 1. Leer el estado de autenticación de Riverpod
    final authState = ref.read(authProvider);

    // 2. Verificar si el usuario está autenticado y si tiene un token
    if (authState.status == AuthStatus.authenticated && authState.authData != null) {
      final token = authState.authData!.token;

      // 3. Añadir el token a la cabecera
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    // Continuar con la petición
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Manejo del error 401 (Token inválido o expirado)
    if (err.response?.statusCode == 401) {
      print('ERROR 401: Token expirado o inválido. Cerrando sesión.');
      // 1. Forzar el cierre de sesión globalmente
      ref.read(authProvider.notifier).logout(); 

      // 2. Opcional: Podrías intentar refrescar el token aquí si tu backend lo soporta
    }

    super.onError(err, handler);
  }
}