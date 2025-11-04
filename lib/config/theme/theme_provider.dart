import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Definición del proveedor de tema: Se inicializa con el tema del sistema.
final themeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system; 
});