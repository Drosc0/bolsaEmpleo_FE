import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';

class ApiService {
  final String baseUrl = getBaseUrl();

  // Esta funcion es para cuando la cosa va mal. Si el servidor se queja, aqui lo pillamos.
  void _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return; // Éxito
    } else {
      // Manejo de errores HTTP estándar (incluyendo 400 Bad Request, 401 Unauthorized, etc.)
      final errorBody = jsonDecode(response.body);
      final message = errorBody['message'] is List
          ? errorBody['message'][0] // Si NestJS devuelve un array de errores
          : errorBody['message'] ?? 'Error de servidor desconocido';

      throw HttpException(message: message, statusCode: response.statusCode);
    }
  }

  Map<String, String> _buildHeaders({String? token}) {
    return {
      'Content-Type': 'application/json',
      // Adjuntamos el JWT para rutas protegidas
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ==========================================================
  // MÉTODOS HTTP REALES
  // ==========================================================

  // 1. POST: Esto es para enviar cosas nuevas, como cuando te registras.
  Future<http.Response> post(
    String path,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl$path');

    final response = await http.post(
      url,
      headers: _buildHeaders(token: token),
      body: jsonEncode(body),
    );

    _handleResponse(response);
    return response;
  }

  // 2. GET: Esto es para pedir info, dame dame dame.
  Future<http.Response> get(String path, {String? token}) async {
    final url = Uri.parse('$baseUrl$path');

    final response = await http.get(url, headers: _buildHeaders(token: token));

    _handleResponse(response);
    return response;
  }

  // 3. PUT: Esto es para cambiar cosas que ya existen, como editar tu perfil.
  Future<http.Response> put(
    String path,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl$path');

    final response = await http.put(
      url,
      headers: _buildHeaders(token: token),
      body: jsonEncode(body),
    );

    _handleResponse(response);
    return response;
  }

  // 4. DELETE: Esto es para borrar cosas, adios muy buenas.
  Future<http.Response> delete(String path, {String? token}) async {
    final url = Uri.parse('$baseUrl$path');

    final response = await http.delete(
      url,
      headers: _buildHeaders(token: token),
    );

    _handleResponse(response);
    return response;
  }
}

// Clase de Excepción para manejar errores del backend/HTTP
class HttpException implements Exception {
  final String message;
  final int statusCode;

  HttpException({required this.message, required this.statusCode});

  @override
  String toString() => 'HttpException: $message (Status: $statusCode)';
}
