import 'dart:convert';
import 'api_service.dart';
import '../models/aspirant_profile.dart'; 

class ProfileService {
  final ApiService _api = ApiService();

  Future<dynamic> getMyProfile() async {
    final response = await _api.get('/aspirants/profile');
    
    final data = json.decode(response.body);
    // Idealmente, mapearías esto a un objeto Dart/Flutter (POJO)
    // return AspirantProfile.fromJson(data);
    return data; 
  }

  Future<void> addSkill(String name, int level) async {
    await _api.post('/aspirants/skills', {
      'name': name,
      'level': level,
    });
  }
}