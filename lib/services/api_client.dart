import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
 //  Android: 'http://10.0.2.2:3001/api'
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
 headers['Authorization'] = 'Bearer $token'; 
 }
 return headers;
 }

 // -----------------------------------------------------------------
 // ✅ MÉTODO POST (Mantenido)
 // -----------------------------------------------------------------
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
 
 // -----------------------------------------------------------------
 // ✅ MÉTODO PUT (Añadido para el CRUD de ofertas/perfiles)
 // -----------------------------------------------------------------
 Future<http.Response> put(String endpoint, dynamic body) async {
 final url = Uri.parse('$_baseUrl$endpoint');
 final headers = await _getHeaders();
 
final response = await http.put(
 url,
 headers: headers,
 body: json.encode(body),
 );
 
_handleErrors(response);
 return response;
}

 // -----------------------------------------------------------------
 // ✅ MÉTODO DELETE (Añadido para eliminar ofertas/ítems de CV)
 // -----------------------------------------------------------------
 Future<http.Response> delete(String endpoint) async {
 final url = Uri.parse('$_baseUrl$endpoint');
 final headers = await _getHeaders();
 
 final response = await http.delete(
 url,
 headers: headers,
 );
 
 _handleErrors(response);
 return response;
 }

 // -----------------------------------------------------------------
 // ✅ MÉTODO GET CORREGIDO (Incluye el parámetro queryParams)
// -----------------------------------------------------------------
 Future<http.Response> get(String endpoint, {Map<String, dynamic>? queryParams}) async {
 Uri uri = Uri.parse('$_baseUrl$endpoint');
 
 // Añade los parámetros si existen (ej: ?page=1&search=flutter)
 if (queryParams != null && queryParams.isNotEmpty) {
uri = uri.replace(queryParameters: queryParams.map((key, value) => MapEntry(key, value.toString())));
}

 final headers = await _getHeaders();
 
final response = await http.get(
uri, // Usa la URI potencialmente modificada
headers: headers,
 );
 
 _handleErrors(response);
 return response;
}
 
 // --- Manejo de Errores (Mantenido) ---

 void _handleErrors(http.Response response) {
 if (response.statusCode >= 400) {
 // Intenta decodificar el cuerpo para obtener el mensaje de error del backend
try {
 final data = json.decode(response.body);
String message = data['message'] is List 
 ? data['message'].join(', ') 
: (data['message'] ?? 'Ocurrió un error desconocido.');

 throw Exception('Error ${response.statusCode}: $message');
} catch (e) {
// Falla al decodificar el JSON (ej: error 500 HTML)
 throw Exception('Error ${response.statusCode}: No se pudo decodificar el mensaje del servidor.');
 }
 }
 }
}