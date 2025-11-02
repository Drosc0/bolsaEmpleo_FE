/// @brief Contiene la lógica de negocio para la gestión del perfil del aspirante
/// y las interacciones con la API de bolsa de empleo.
library;

import 'package:bolsa_empleo/models/experience_item.dart';
import 'package:bolsa_empleo/models/skill_item.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:erp_food_bites/config/config.dart';
import '../models/aspirant_profile.dart';

// Nota: Se asume que el token JWT es válido para ambos backends (ERP y Bolsa de Empleo)
// y se ha guardado previamente en el secure storage.

class RecruitmentViewModel extends ChangeNotifier {
  bool _isLoading = false;
  AspirantProfile? _profile; // Un solo perfil por usuario logueado
  String? _errorMessage;

  bool get isLoading => _isLoading;
  AspirantProfile? get profile => _profile;
  String? get errorMessage => _errorMessage;

  // Base URL ajustada para el módulo de reclutamiento (ej. /api/recruitment)
  final String _baseUrl = '$kBaseUrl/recruitment/profile'; 
  final _secureStorage = const FlutterSecureStorage();

  RecruitmentViewModel() {
    fetchProfile();
  }

  // --- LÓGICA DE AUTENTICACIÓN ---

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _secureStorage.read(key: 'jwt');
    if (token == null) {
      return {}; 
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // --- MOCK DATA (RESPALDO) ---

  AspirantProfile _fetchMockProfile() {
    // Datos de ejemplo para el modo de desarrollo
    return AspirantProfile(
      id: 1,
      name: 'Simulador Aspirante',
      email: 'aspirante.mock@ejemplo.com',
      phone: '611-222-333',
      summary: 'Desarrollador Flutter con experiencia en MVVM y APIs REST.',
      experience: [
        ExperienceItem(
          title: 'Desarrollador Frontend',
          company: 'Tech Solutions Inc.',
          location: 'Remoto',
          startDate: DateTime(2022, 1, 1),
          endDate: DateTime(2024, 6, 30),
          description: 'Lideré el desarrollo de dos aplicaciones móviles con Flutter.',
        ),
      ],
      skills: [
        SkillItem(name: 'Flutter', category: 'Técnica', level: 'Experto'),
        SkillItem(name: 'NestJS', category: 'Técnica', level: 'Intermedio'),
        SkillItem(name: 'Inglés', category: 'Idioma', level: 'C1'),
      ],
    );
  }

  // --- OPERACIONES CRUD (PROFILE) ---

  // Obtiene el perfil del aspirante asociado al usuario logueado
  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final headers = await _getAuthHeaders();
      if (headers.isEmpty) {
        _errorMessage = 'Fallo de autenticación: Token no encontrado.';
        _profile = _fetchMockProfile();
        return;
      }
      
      final response = await http.get(Uri.parse(_baseUrl), headers: headers);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _profile = AspirantProfile.fromJson(data);
        debugPrint('Perfil de aspirante cargado con éxito.');
      } else if (response.statusCode == 404) {
        // 404 significa que el usuario no tiene un perfil creado aún
        _errorMessage = 'Aún no tienes un perfil de aspirante creado.';
        _profile = null; 
      } else if (response.statusCode == 401) {
        _errorMessage = 'Sesión no autorizada o expirada.';
        _profile = _fetchMockProfile();
      } else {
        _errorMessage = 'Error al cargar el perfil. Código: ${response.statusCode}';
        _profile = _fetchMockProfile();
      }
    } catch (e) {
      debugPrint('Error de conexión al cargar perfil: $e');
      _errorMessage = 'Error de conexión. Verifique la IP o la red.';
      _profile = _fetchMockProfile();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Crea el perfil inicial del aspirante
  Future<bool> createProfile(AspirantProfile newProfile) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: headers,
        body: json.encode(newProfile.toJson()),
      );

      if (response.statusCode == 201) {
        _profile = AspirantProfile.fromJson(json.decode(response.body));
        notifyListeners();
        return true;
      } else {
        debugPrint('Error al crear perfil: ${response.statusCode}');
        _errorMessage = 'Error al crear perfil. Código: ${response.statusCode}';
        return false;
      }
    } catch (e) {
      debugPrint('Error de conexión al crear perfil: $e');
      _errorMessage = 'Error de conexión al crear perfil: $e';
      return false;
    }
  }

  // Actualiza el perfil existente
  Future<bool> updateProfile(AspirantProfile updatedProfile) async {
    if (updatedProfile.id == null) return false;
    
    try {
      final headers = await _getAuthHeaders();
      final response = await http.put(
        Uri.parse('$_baseUrl/${updatedProfile.id}'),
        headers: headers,
        body: json.encode(updatedProfile.toJson()),
      );

      if (response.statusCode == 200) {
        _profile = AspirantProfile.fromJson(json.decode(response.body));
        notifyListeners();
        return true;
      } else {
        debugPrint('Error al actualizar perfil: ${response.statusCode}');
        _errorMessage = 'Error al actualizar perfil. Código: ${response.statusCode}';
        return false;
      }
    } catch (e) {
      debugPrint('Error de conexión al actualizar perfil: $e');
      _errorMessage = 'Error de conexión al actualizar perfil: $e';
      return false;
    }
  }

  // Elimina el perfil (opcional, pero útil para la gestión de la cuenta)
  Future<bool> deleteProfile(int id) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.delete(Uri.parse('$_baseUrl/$id'), headers: headers);

      if (response.statusCode == 200) {
        _profile = null;
        notifyListeners();
        return true;
      } else {
        debugPrint('Error al eliminar perfil: ${response.statusCode}');
        _errorMessage = 'Error al eliminar perfil. Código: ${response.statusCode}';
        return false;
      }
    } catch (e) {
      debugPrint('Error de conexión al eliminar perfil: $e');
      _errorMessage = 'Error de conexión al eliminar perfil: $e';
      return false;
    }
  }
}