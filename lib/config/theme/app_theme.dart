import 'package:flutter/material.dart';

class AppTheme {

  // Definición de Colores
  // Verde claro primario
  static const Color lightPrimaryGreen = Color(0xFF81C784); // Shade de Light Green 500
  
  // Anaranjado/Naranja secundario 
  static const Color accentOrange = Color(0xFFFF9800); // Naranja estándar
  
  // Color primario oscuro
  static const Color darkPrimaryDeepBlue = Color(0xFF1A237E); // Deep Indigo/Dark Blue

  
  // 1. TEMA CLARO
  // Primario: Verde Clarito
  // Secundario: Anaranjado
 
  static ThemeData get lightTheme {
    // Base del tema claro
    final base = ThemeData.light();
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: lightPrimaryGreen,     // Verde Clarito
        secondary: accentOrange,        // Anaranjado
        tertiary: accentOrange,         
        surface: Colors.white,          // Fondo de pantalla muy claro
        onPrimary: Colors.white,        // Texto sobre el primario (verde)
        onSecondary: Colors.black,      // Texto sobre el secundario (naranja)
      ),
      // Ajustes específicos para widgets (AppBar, Card, etc.)
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
        backgroundColor: accentOrange,
      ),
    );
  }

  // 2. TEMA OSCURO
  // Primario: Estándar Oscuro 
  // Secundario: Naranja

  static ThemeData get darkTheme {
    // Base del tema oscuro (Material 3)
    final base = ThemeData.dark();
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: const Color.fromARGB(255, 36, 53, 240),   // Estándar Oscuro (Deep Blue)
        secondary: accentOrange,        // Naranja
        tertiary: accentOrange,
        brightness: Brightness.dark,
        surface: const Color(0xFF1E1E1E), // Fondo de pantalla oscuro
        onPrimary: Colors.white,
        onSecondary: Colors.black,
      ),
      // Ajustes específicos para widgets (AppBar, Card, etc.)
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
        backgroundColor: accentOrange,
      ),
      // Ajuste para el color de las tarjetas (Surface Container)
      cardColor: const Color(0xFF1E1E1E), 
    );
  }
}