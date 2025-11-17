import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/home_view_model.dart';
import '../../shared/offer_card.dart'; // Widget OfferCard a crear

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plataforma de Reclutamiento'),
        centerTitle: false,
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          switch (viewModel.state) {
            case ViewState.loading:
              return const Center(child: CircularProgressIndicator());
            case ViewState.error:
              return Center(child: Text('Error: ${viewModel.errorMessage}'));
            case ViewState.loaded:
              return _buildResponsiveLayout(context, viewModel);
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
  ) {
    // Media Query para determinar el ancho de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;

    // Define el punto de quiebre para el layout de dos columnas (Tablet/Web)
    if (screenWidth < 600) {
      // 1. MÓVIL (Una sola columna vertical)
      return _MobileLayout(viewModel: viewModel);
    } else {
      // 2. TABLET/WEB (Layout de dos columnas)
      // Ajusta la cantidad de ofertas por fila
      final crossAxisCount = screenWidth > 900 ? 4 : 2; 

      return _TabletWebLayout(
        viewModel: viewModel,
        crossAxisCount: crossAxisCount,
      );
    }
  }
}

// ==========================================================
// MÓVIL (Una Columna)
// ==========================================================

class _MobileLayout extends StatelessWidget {
  final HomeViewModel viewModel;
  const _MobileLayout({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Estadísticas y Enlace (Ocupa todo el ancho)
          _StatsAndAuthSection(stats: viewModel.stats),
          const SizedBox(height: 24),
          
          // 2. Título de Ofertas
          Text(
            'Últimas Ofertas',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          
          // 3. Ofertas (Una columna, 1 oferta por 'row')
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
  final int crossAxisCount; // 2 para Tablet, 4 para Web

  const _TabletWebLayout({
    required this.viewModel,
    required this.crossAxisCount,
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
          child: _StatsAndAuthSection(stats: viewModel.stats),
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
                
                // GridView con ofertas (2 o 4 por fila)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: viewModel.offers.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount, 
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                    childAspectRatio: 3 / 2, // Ajusta la relación de aspecto de la tarjeta
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
  const _StatsAndAuthSection({this.stats});

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
                Text('Estadísticas de la Comunidad', style: Theme.of(context).textTheme.titleLarge),
                const Divider(),
                _StatRow(label: 'Usuarios Registrados', count: stats!.totalUsers),
                _StatRow(label: 'Aspirantes', count: stats!.aspirants),
                _StatRow(label: 'Empresas', count: stats!.companies),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Enlace para Loguearse/Registrarse
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Navegar a la página de Login
            print('Navegar a Login');
          },
          icon: const Icon(Icons.login),
          label: const Text('Iniciar Sesión / Registrarse', style: TextStyle(fontSize: 16)),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
          ),
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
          Text(count.toString(), style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}