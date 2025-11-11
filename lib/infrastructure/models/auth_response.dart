class AuthResponse {
  /// Token de acceso para futuras peticiones a la API.
  final String token; 
  
  /// Identificador único del usuario (UUID de la base de datos).
  final String userId; 
  
  /// Rol del usuario ('aspirante' o 'empresa').
  final String role; 

  AuthResponse({
    required this.token,
    required this.userId,
    required this.role,
  });

  // -------------------------------------------------------------------
  // CONSTRUCTOR DE FACTORÍA DESDE JSON
  // -------------------------------------------------------------------

  /// Constructor de factoría para crear una instancia de AuthResponse 
  /// a partir de un mapa JSON (respuesta del backend).
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // 1. Verificación Crítica de Campos Obligatorios.
    if (json['token'] == null || json['userId'] == null || json['role'] == null) {
      throw const FormatException('Faltan campos obligatorios (token, userId, o role) en la respuesta del servidor.');
    }
    
    // 2. Mapeo Defensivo
    return AuthResponse(
      token: json['token'] as String,
      // Usamos .toString() por seguridad en caso de que el backend envíe un ID numérico,
      // pero el modelo espera un String.
      userId: json['userId'].toString(), 
      // CRÍTICO: Asegúrate de que la clave del rol sea exactamente 'role'.
      role: json['role'] as String,
    );
  }

  // -------------------------------------------------------------------
  // CONVERSIÓN A JSON
  // -------------------------------------------------------------------

  /// Método auxiliar para convertir la instancia a JSON 
  /// (útil para guardar en SecureStorage si es necesario).
  Map<String, dynamic> toJson() => {
    'token': token,
    'userId': userId,
    'role': role,
  };
}