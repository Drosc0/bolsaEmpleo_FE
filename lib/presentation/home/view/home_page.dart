import 'package:bolsa_empleo/presentation/auth/viewmodel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/home_view_model.dart';
import '../../shared/offer_card.dart';
import '../../../data/models/stats_model.dart';
import '../../auth/view/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // El AuthViewModel nos dirá si debemos mostrar el botón de Login/Registro.
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plataforma de Reclutamiento'),
        centerTitle: false,
        actions: authViewModel.isLoggedIn
            ? [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    authViewModel.logout();
                  },
                  tooltip: 'Cerrar Sesión',
                ),
              ]
            : null, // No muestra acciones si no está logueado
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, homeViewModel, child) {
          switch (homeViewModel.state) {
            case ViewState.loading:
              return const Center(child: CircularProgressIndicator());
            case ViewState.error:
              return Center(
                child: Text('Error: ${homeViewModel.errorMessage}'),
              );
            case ViewState.loaded:
              return _buildResponsiveLayout(
                context,
                homeViewModel,
                authViewModel.isLoggedIn,
              );
            default:
              return const Center(child: Text('Cargando...'));
          }
        },
      ),
    );
  }

  // Lógica Responsiva Principal
  Widget _buildResponsiveLayout(
    BuildContext context,
    HomeViewModel viewModel,
    bool isLoggedIn,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      // 1. MÓVIL (Una sola columna vertical)
      return _MobileLayout(viewModel: viewModel, isLoggedIn: isLoggedIn);
    } else {
      // 2. TABLET(Layout de dos columnas)/WEB(Layout de cuatro/seis columnas)
      int crossAxisCount;
      if (screenWidth >= 1600) {
        // pantallas extra grandes
        crossAxisCount = 6;
      } else if (screenWidth > 900) {
        // Web
        crossAxisCount = 4;
      } else {
        // Tablet
        crossAxisCount = 2;
      }

      return _TabletWebLayout(
        viewModel: viewModel,
        crossAxisCount: crossAxisCount,
        isLoggedIn: isLoggedIn,
      );
    }
  }
}

// ==========================================================
// MÓVIL (Una Columna)
// ==========================================================

class _MobileLayout extends StatelessWidget {
  final HomeViewModel viewModel;
  final bool isLoggedIn;
  const _MobileLayout({required this.viewModel, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Estadísticas y Enlace (Ocupa todo el ancho)
          _StatsAndAuthSection(stats: viewModel.stats, isLoggedIn: isLoggedIn),
          const SizedBox(height: 24),

          // 2. Título de Ofertas
          Text(
            'Últimas Ofertas',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),

          // 3. Ofertas (Una columna, 1 oferta por 'row')
          if (viewModel.offers.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('No hay ofertas disponibles en este momento.'),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewModel.offers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: OfferCard(offer: viewModel.offers[index]),
                );
              },
            ),
        ],
      ),
    );
  }
}

// ==========================================================
// TABLET/WEB (Diseño de Dos Columnas)
// ==========================================================

class _TabletWebLayout extends StatelessWidget {
  final HomeViewModel viewModel;
  final int crossAxisCount;
  final bool isLoggedIn;

  const _TabletWebLayout({
    required this.viewModel,
    required this.crossAxisCount,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // COLUMNA 1/3 (Estadísticas y Auth)
        Container(
          width: MediaQuery.of(context).size.width * 0.33,
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              right: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: _StatsAndAuthSection(
            stats: viewModel.stats,
            isLoggedIn: isLoggedIn,
          ),
        ),

        // COLUMNA 2/3 (Ofertas)
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Últimas Ofertas',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),

                // GridView con ofertas (2, 4 o 6 por fila)
                if (viewModel.offers.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'No hay ofertas disponibles en este momento.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: viewModel.offers.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                      childAspectRatio: 3 / 2,
                    ),
                    itemBuilder: (context, index) {
                      return OfferCard(offer: viewModel.offers[index]);
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================================
// SECCIÓN REUTILIZABLE (Estadísticas y Botones)
// ==========================================================

class _StatsAndAuthSection extends StatelessWidget {
  final AppStats? stats;
  final bool isLoggedIn;

  const _StatsAndAuthSection({this.stats, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    if (stats == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Tarjeta de Estadísticas
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estadísticas de la Comunidad',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Divider(),
                _StatRow(
                  label: 'Usuarios Registrados',
                  count: stats!.totalUsers,
                ),
                _StatRow(label: 'Aspirantes', count: stats!.aspirants),
                _StatRow(label: 'Empresas', count: stats!.companies),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Enlace para Loguearse/Registrarse (SI NO ESTÁ LOGUEADO)
        if (!isLoggedIn)
          ElevatedButton.icon(
            onPressed: () {
              // Navegar a la página de Login
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            icon: const Icon(Icons.login),
            label: const Text(
              'Iniciar Sesión / Registrarse',
              style: TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
            ),
          ),

        // Mensaje si está logueado
        // hacer un ifelse con !isLoggedIn si fuese posible???
        if (isLoggedIn)
          Text(
            '¡Bienvenido de nuevo! Usa el menú superior para acceder a tu dashboard.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final int count;

  const _StatRow({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(
            count.toString(),
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
