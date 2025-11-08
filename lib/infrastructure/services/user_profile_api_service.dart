import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/services/dio_provider.dart'; // Importa el DioProvider

// --------------------------------------------------------------------------
// 1. Modelos (DTOs)
// --------------------------------------------------------------------------

// Modelo de datos para la Experiencia Laboral
class ExperienceDto {
  final String id;
  final String title;
  final String company;
  final DateTime startDate;
  final DateTime? endDate;
  final String description;

  ExperienceDto({
    required this.id,
    required this.title,
    required this.company,
    required this.startDate,
    this.endDate,
    required this.description,
  });

  factory ExperienceDto.fromJson(Map<String, dynamic> json) => ExperienceDto(
    id: json['id'],
    title: json['title'],
    company: json['company'],
    startDate: DateTime.parse(json['startDate']),
    endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    description: json['description'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'company': company,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'description': description,
  };
}

// Modelo de datos principal del Perfil del Aspirante
class UserProfileDto {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String summary;
  final List<ExperienceDto> experience;

  UserProfileDto({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.summary,
    required this.experience,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) => UserProfileDto(
    userId: json['userId'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'] ?? '',
    summary: json['summary'] ?? '',
    experience: (json['experience'] as List<dynamic>?)
        ?.map((e) => ExperienceDto.fromJson(e))
        .toList() ?? [],
  );

  // DTO para enviar al backend (excluyendo datos que el servidor maneja, como el email)
  Map<String, dynamic> toUpdateJson() => {
    'name': name,
    'phone': phone,
    'summary': summary,
    // La experiencia se maneja en un endpoint separado o se envía completa
    // Para simplificar, asumiremos que se envía experiencia en otro endpoint.
  };
}


// --------------------------------------------------------------------------
// 2. Servicio API
// --------------------------------------------------------------------------

class UserProfileApiService {
  final Dio _dio;

  UserProfileApiService(this._dio);

  /// Obtiene el perfil completo de un usuario.
  Future<UserProfileDto> fetchProfile(String userId) async {
    final response = await _dio.get('/applicant/profile/$userId');
    
    return UserProfileDto.fromJson(response.data);
  }

  /// Actualiza los campos básicos del perfil.
  Future<void> updateProfile(String userId, UserProfileDto profile) async {
    // Usamos el DTO de actualización que contiene solo los campos mutables
    await _dio.patch('/applicant/profile/$userId', data: profile.toUpdateJson());
  }

  /// Agrega una nueva entrada de experiencia laboral.
  Future<ExperienceDto> addExperience(String userId, ExperienceDto experience) async {
    final response = await _dio.post(
      '/applicant/profile/$userId/experience', 
      data: experience.toJson()
    );
    return ExperienceDto.fromJson(response.data); 
  }
  
  /// Actualiza una entrada de experiencia laboral existente.
  Future<void> updateExperience(String userId, String experienceId, ExperienceDto experience) async {
    // El ID de la experiencia debe ir en el path o en el body, depende del backend (NestJS)
    //  PATCH : /applicant/profile/:userId/experience/:experienceId
    await _dio.patch(
      '/applicant/profile/$userId/experience/$experienceId', 
      data: experience.toJson()
    );
  }

  /// Elimina una entrada de experiencia laboral.
  Future<void> deleteExperience(String userId, String experienceId) async {
    await _dio.delete('/applicant/profile/$userId/experience/$experienceId');
  }
}

// --------------------------------------------------------------------------
// 3. Provider
// --------------------------------------------------------------------------

final userProfileApiServiceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return UserProfileApiService(dio);
});