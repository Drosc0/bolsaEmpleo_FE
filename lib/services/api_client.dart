import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  //  Android: 'http://10.0.2.2:3001/api'
  // emulador de iOS/Desktop/Web: 'http://localhost:3001/api'
  static const String _baseUrl = 'http://10.0.2.2:3001/api'; 

  // --- Funciones auxiliares para obtener el token y headers ---

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    
    final headers = {
      'Content-Type': 'application/json',
    };

    if (token != null) {
      // Adjuntar el token JWT para las rutas protegidas
      headers['Authorization'] = 'Bearer $token'; 
    }
    return headers;
  }

  // --- Función para manejar peticiones POST/PUT/DELETE ---

  Future<http.Response> post(String endpoint, dynamic body) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final headers = await _getHeaders();
    
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    
    _handleErrors(response);
    return response;
  }
  
  // --- Función para manejar peticiones GET ---
  
  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final headers = await _getHeaders();
    
    final response = await http.get(
      url,
      headers: headers,
    );
    
    _handleErrors(response);
    return response;
  }
  
  // --- Manejo de Errores (opcional, pero vital) ---
  
  void _handleErrors(http.Response response) {
    if (response.statusCode >= 400) {
      final data = json.decode(response.body);
      String message = data['message'] ?? 'Ocurrió un error desconocido.';
      
      // Puedes lanzar una excepción personalizada aquí
      throw Exception('Error ${response.statusCode}: $message');
    }
  }
}