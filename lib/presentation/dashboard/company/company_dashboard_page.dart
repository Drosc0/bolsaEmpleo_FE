import 'package:flutter/material.dart';

class CompanyDashboardPage extends StatelessWidget {
  const CompanyDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Empresa')),
      body: Row(
        children: [
          // COLUMNA 1: Datos de la Empresa y Edición
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blue[50],
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Perfil de Empresa',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  // Placeholder para datos
                  const Text('Empresa: Tech Solutions S.L.'),
                  const Text('Email: contacto@techsolutions.com'),
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

          // COLUMNA 2: Gestión de Ofertas
          Expanded(
            flex: 2, // Más ancho para el contenido principal
            child: Column(
              children: [
                // FILA 1: Ofertas Recientes y Crear Oferta
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      // Sub-Columna 1: Ofertas Recientes (Resumen)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Resumen Reciente',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 10),
                              const Expanded(
                                child: Center(
                                  child: Text('No hay ofertas recientes.'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const VerticalDivider(width: 1),
                      // Sub-Columna 2: Formulario Crear Oferta
                      Expanded(
                        child: Container(
                          color: Colors.green[50],
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nueva Oferta',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 10),
                              // Placeholder formulario
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Título',
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text('Crear Oferta'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // FILA 2: Todas las Ofertas Creadas
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Todas mis Ofertas',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 10),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'No has creado ninguna oferta todavía.',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
