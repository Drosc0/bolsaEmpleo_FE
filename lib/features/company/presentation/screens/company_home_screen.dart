import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../application/auth/auth_provider.dart'; 

class CompanyHomeScreen extends ConsumerWidget {
  const CompanyHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Acceder al Notifier de Autenticación para el Logout
    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Empresa'),
        actions: [
          // Botón de Logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: authNotifier.logout,
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      // Estructura principal: Lista de ofertas creadas por la empresa
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ofertas de Trabajo Publicadas',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Divider(),
            // Aquí iría el Consumer que escucha el CompanyOffersViewModel
            Expanded(
              child: Center(
                child: Text('Vista de ofertas creadas y su estado (Activa/Cerrada/Pendiente).'),
                // Reemplazar con ListView.builder(itemBuilder: ...)
              ),
            ),
          ],
        ),
      ),
    );
  }
}