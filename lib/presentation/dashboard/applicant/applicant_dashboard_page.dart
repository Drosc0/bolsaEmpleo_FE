import 'package:flutter/material.dart';

class ApplicantDashboardPage extends StatelessWidget {
  const ApplicantDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Aspirante')),
      body: Row(
        children: [
          // COLUMNA 1: Datos del Perfil y Edición
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blue[50],
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mi Perfil',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  // Placeholder para datos
                  const Text('Nombre: Juan Pérez'),
                  const Text('Email: juan@example.com'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navegar a editar perfil
                    },
                    child: const Text('Modificar Datos'),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 1),

          // COLUMNA 2: Ofertas Aplicadas
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mis Candidaturas',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  // Placeholder para lista vacía
                  const Expanded(
                    child: Center(
                      child: Text('No has aplicado a ninguna oferta aún.'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 1),

          // COLUMNA 3: Sugerencias
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.orange[50],
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sugerencias para ti',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  // Placeholder para sugerencias vacías
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No hay sugerencias disponibles por el momento.',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
