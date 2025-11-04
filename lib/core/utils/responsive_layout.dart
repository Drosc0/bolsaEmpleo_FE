import 'package:flutter/material.dart';

// Puntos de ruptura para diseño responsivo
const int kMobileBreakpoint = 600;
const int kTabletBreakpoint = 1024;

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget web;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.web,
  });

  // Método estático para verificar el tipo de pantalla
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < kMobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= kMobileBreakpoint &&
      MediaQuery.of(context).size.width < kTabletBreakpoint;

  static bool isWeb(BuildContext context) =>
      MediaQuery.of(context).size.width >= kTabletBreakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        
        // Muestra el diseño para Web/Pantalla Grande
        if (width >= kTabletBreakpoint) {
          return web;
        } 
        // Muestra el diseño para Tablet
        else if (width >= kMobileBreakpoint) {
          return tablet ?? mobile; // Si no hay tablet, usa el móvil
        } 
        // Muestra el diseño para Móvil
        else {
          return mobile;
        }
      },
    );
  }
}