import 'package:bolsa_empleo/presentation/auth/viewmodel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/home_view_model.dart';
import '../../shared/offer_card.dart';
import '../../../data/models/stats_model.dart';
import '../../../data/models/job_offer_model.dart';
import '../../auth/view/login_page.dart';
import '../../common/viewmodel/theme_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // El AuthViewModel nos dirá si debemos mostrar el botón de Login/Registro.
    final authViewModel = Provider.of<AuthViewModel>(context);
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 770;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plataforma de Reclutamiento'),
        centerTitle: false,
        actions: [
          // Theme Toggle Button (Always visible)
          IconButton(
            icon: Icon(
              themeViewModel.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeViewModel.toggleTheme();
            },
            tooltip: themeViewModel.isDarkMode ? 'Modo Claro' : 'Modo Oscuro',
          ),

          // Login Icon (Visible only on small screens if not logged in)
          if (isSmallScreen && !authViewModel.isLoggedIn)
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              tooltip: 'Iniciar Sesión',
            ),

          if (authViewModel.isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                authViewModel.logout();
              },
              tooltip: 'Cerrar Sesión',
            ),
        ],
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
                isSmallScreen,
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
    bool isSmallScreen,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600 && screenWidth < 1100;

    if (screenWidth < 600) {
      // 1. MÓVIL (Una sola columna vertical)
      return _MobileLayout(
        viewModel: viewModel,
        isLoggedIn: isLoggedIn,
        isSmallScreen: isSmallScreen,
      );
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
        isSmallScreen: isSmallScreen,
        isTablet: isTablet,
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
  final bool isSmallScreen;

  const _MobileLayout({
    required this.viewModel,
    required this.isLoggedIn,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Estadísticas y Enlace (Ocupa todo el ancho)
          _StatsAndAuthSection(
            stats: viewModel.stats,
            isLoggedIn: isLoggedIn,
            isSmallScreen: isSmallScreen,
            isTablet: false,
          ),
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
                  child: OfferCard(
                    offer: viewModel.offers[index],
                    onTap: () => _showOfferDetails(
                      context,
                      viewModel.offers[index],
                      isLoggedIn,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// TABLET/WEB (Diseño de Dos Columnas)

class _TabletWebLayout extends StatelessWidget {
  final HomeViewModel viewModel;
  final int crossAxisCount;
  final bool isLoggedIn;
  final bool isSmallScreen;
  final bool isTablet;

  const _TabletWebLayout({
    required this.viewModel,
    required this.crossAxisCount,
    required this.isLoggedIn,
    required this.isSmallScreen,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // altura de tarjetas para (900px - 1240px)
    double childAspectRatio = 1.1; // Valor por defecto
    if (screenWidth >= 900 && screenWidth <= 1240) {
      childAspectRatio = 0.85; // Tarjetas más altas
    }

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
            isSmallScreen: isSmallScreen,
            isTablet: isTablet,
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
                      childAspectRatio: childAspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      return OfferCard(
                        offer: viewModel.offers[index],
                        onTap: () => _showOfferDetails(
                          context,
                          viewModel.offers[index],
                          isLoggedIn,
                        ),
                      );
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

//REUTILIZABLE (Estadísticas y Botones)

class _StatsAndAuthSection extends StatelessWidget {
  final AppStats? stats;
  final bool isLoggedIn;
  final bool isSmallScreen;
  final bool isTablet;

  const _StatsAndAuthSection({
    this.stats,
    required this.isLoggedIn,
    required this.isSmallScreen,
    required this.isTablet,
  });

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
                  'Estadísticas',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Divider(),
                _StatRow(
                  label: 'Usuarios',
                  count: stats!.totalUsers,
                  icon: Icons.group,
                  isTablet: isTablet,
                ),
                _StatRow(
                  label: 'Aspirantes',
                  count: stats!.aspirants,
                  icon: Icons.person,
                  isTablet: isTablet,
                ),
                _StatRow(
                  label: 'Empresas',
                  count: stats!.companies,
                  icon: Icons.business,
                  isTablet: isTablet,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Enlace para Loguearse/Registrarse (SI NO ESTÁ LOGUEADO y NO ES PANTALLA PEQUEÑA)
        if (!isLoggedIn && !isSmallScreen)
          ElevatedButton.icon(
            onPressed: () {
              // Navegar a la página de Login
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            icon: const Icon(Icons.login),
            label: const Text('Ingresar', style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
            ),
          ),

        // Mensaje si está logueado
        if (isLoggedIn)
          Text(
            '¡Bienvenido!',
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
  final IconData icon;
  final bool isTablet;

  const _StatRow({
    required this.label,
    required this.count,
    required this.icon,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isTablet)
            Tooltip(
              message: label,
              child: Icon(
                icon,
                size: 28,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          else
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

void _showOfferDetails(BuildContext context, JobOffer offer, bool isLoggedIn) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(offer.title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Empresa: ${offer.companyName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Ubicación: ${offer.location}'),
            const SizedBox(height: 8),
            const Text(
              'Descripción:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(offer.description),
            const SizedBox(height: 8),
            Text('Salario: ${offer.salaryRange}'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (!isLoggedIn) {
              Navigator.pop(context); // Close dialog
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            } else {
              try {
                final viewModel = Provider.of<HomeViewModel>(
                  context,
                  listen: false,
                );
                await viewModel.applyToJob(offer.id);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Te has postulado exitosamente'),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al postular: $e')),
                  );
                }
              }
            }
          },
          child: const Text('Postularme'),
        ),
      ],
    ),
  );
}
