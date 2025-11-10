class AuthResponse {
  /// Token de acceso para futuras peticiones a la API.
  final String token; 
  
  /// Identificador único del usuario (UUID de la base de datos).
  final String userId; 
  
  /// Rol del usuario ('applicant' o 'company').
  final String role; 

  AuthResponse({
    required this.token,
    required this.userId,
    required this.role,
  });

  /// Constructor de factoría para crear una instancia de AuthResponse 
  /// a partir de un mapa JSON (respuesta del backend).
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error') || json['token'] == null) {
      // Manejar el caso de respuesta de error si es necesario,
      // aunque el servicio API debería manejar esto.
      throw Exception('Invalid authentication response format or token missing.');
    }
    
    return AuthResponse(
      token: json['token'] as String,
      // En un flujo real, el backend también debería devolver el userId y el role
      // junto con el token después del login/registro.
      userId: json['userId'] as String, 
      role: json['role'] as String,
    );
  }

  /// Método auxiliar para convertir la instancia a JSON (útil para guardar en SecureStorage si es necesario).
  Map<String, dynamic> toJson() => {
        'token': token,
        'userId': userId,
        'role': role,
      };
}