import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/theme_provider.dart'; 


// Valores de ejemplo para los breakpoints 
const double kMobileBreakpoint = 600.0;
const double kTabletBreakpoint = 1024.0; 

// --- WIDGET PRINCIPAL ---
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void toggleTheme() {
      final currentMode = ref.read(themeProvider);
      ref.read(themeProvider.notifier).state = 
          currentMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    }

    // Usamos LayoutBuilder directamente para evitar depender de un ResponsiveLayout externo
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width >= kTabletBreakpoint) {
          return _WebHomeLayout(toggleTheme: toggleTheme);
        } else {
          // Usamos el mismo layout para móvil y tablet, y ajustamos internamente
          return _MobileTabletHomeLayout(toggleTheme: toggleTheme);
        }
      },
    );
  }
}

// --------------------------------------------------------------------------
// --- Layout Específico para Móviles/Tablets (Lista y Grid de 2) ---
// --------------------------------------------------------------------------

class _MobileTabletHomeLayout extends StatelessWidget {
  final VoidCallback toggleTheme;

  const _MobileTabletHomeLayout({required this.toggleTheme});

  Widget _buildCategoryChips(BuildContext context) {
    final categories = ['Desarrollo', 'Diseño UX/UI', 'Marketing', 'Finanzas', 'Data Science'];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return Chip(
            label: Text(categories[index], style: const TextStyle(fontSize: 14)),
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            side: BorderSide.none,
          );
        },
      ),
    );
  }

  // Lógica para construir la sección de Ofertas Destacadas (Lista vs Grid 2)
  Widget _buildFeaturedOffers(BuildContext context, double width) {
    // Si el ancho es menor a 600px, usamos Column (Lista Móvil)
    final isMobile = width < kMobileBreakpoint;
    
    if (isMobile) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          JobOfferCard(isMobileList: true),
          JobOfferCard(isMobileList: true),
          JobOfferCard(isMobileList: true),
        ],
      );
    } 
    // Si es Tablet (Ancho 600px a 1024px), usamos Grid de 2
    else {
      return GridView.count(
        crossAxisCount: 2, 
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.5, 
        children: const [
          JobOfferCard(isGrid: true),
          JobOfferCard(isGrid: true),
          JobOfferCard(isGrid: true),
          JobOfferCard(isGrid: true),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JobBoard Pro'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.go('/login'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Campo de Búsqueda
            const Padding(
              padding: EdgeInsets.only(bottom: 25.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar puesto, empresa...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),

            // 2. Cabecera
            const Text(
              'Tu próximo desafío te espera',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 3. Sección de Categorías
            const Text(
              'Explora por Sector',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            _buildCategoryChips(context),
            const SizedBox(height: 30),

            // 4. Listado de Ofertas Recientes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ofertas Destacadas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: () => context.go('/offers'),
                  child: const Text('Ver todas'),
                )
              ],
            ),
            const SizedBox(height: 10),
            
            // LÓGICA DE ADAPTACIÓN
            LayoutBuilder(
              builder: (context, constraints) {
                return _buildFeaturedOffers(context, constraints.maxWidth);
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------------------------------
// --- Layout Específico para Web/Escritorio (Grid de 3 - 1440px+) ---
// --------------------------------------------------------------------------

class _WebHomeLayout extends StatelessWidget {
  final VoidCallback toggleTheme;

  const _WebHomeLayout({required this.toggleTheme});

  Widget _buildWebSidebar(BuildContext context, VoidCallback toggleTheme) {
    return Container(
      width: 250,
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'JobBoard Pro',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.work_history),
            title: const Text('Explorar Ofertas'),
            onTap: () => context.go('/offers'),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Mi Perfil'),
            onTap: () => context.go('/profile'),
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Panel de Empresa'),
            onTap: () => context.go('/company-panel'),
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Login/Registro'),
            onTap: () => context.go('/login'),
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Cambiar Tema'),
            onTap: toggleTheme,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Barra Lateral Fija
          _buildWebSidebar(context, toggleTheme),
          
          // Contenido Principal Centrado
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 60.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200), // Ancho máximo para el contenido
                alignment: Alignment.topCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título y Búsqueda
                    const Text(
                      'Encuentra tu próximo desafío profesional',
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 25),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar puesto, empresa o palabra clave...',
                        prefixIcon: Icon(Icons.search, size: 24),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 40),

                    // Grilla de Ofertas Destacadas (3 Columnas)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ofertas Destacadas',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () => context.go('/offers'),
                          child: const Text('Ver todas'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    
                    // Grid View con 3 columnas (para 1440px+)
                    GridView.count(
                      crossAxisCount: 3, 
                      crossAxisSpacing: 25,
                      mainAxisSpacing: 25,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.2, // Tarjetas más compactas
                      children: const [
                        JobOfferCard(isGrid: true),
                        JobOfferCard(isGrid: true),
                        JobOfferCard(isGrid: true),
                        JobOfferCard(isGrid: true),
                        JobOfferCard(isGrid: true),
                        JobOfferCard(isGrid: true),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------------------------------
// --- Widget Reutilizable para Tarjetas de Ofertas ---
// --------------------------------------------------------------------------

class JobOfferCard extends StatelessWidget {
  final bool isMobileList;
  final bool isGrid;

  const JobOfferCard({super.key, this.isMobileList = false, this.isGrid = false});

  // Este método simula la creación de una etiqueta
  Widget _buildTag(BuildContext context, String text, bool isCompact) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isCompact ? 6 : 8, vertical: isCompact ? 3 : 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: isCompact ? 10 : 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = isGrid; // La grilla es el modo compacto
    
    return Card(
      elevation: isMobileList ? 2 : 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: isMobileList ? const EdgeInsets.only(bottom: 15) : EdgeInsets.zero, 
      
      child: InkWell( 
        onTap: () => context.go('/offers/123'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: isCompact ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
            children: [
              // 1. Logo y Título
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    child: Icon(Icons.laptop_mac, size: 20, color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dev Full Stack (NestJS/Flutter)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: isCompact ? 15 : 17), 
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Tech Innovators S.L.',
                          style: TextStyle(color: Colors.grey, fontSize: isCompact ? 13 : 14), 
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // 2. Etiquetas
              Wrap(
                spacing: 6.0,
                runSpacing: 4.0,
                children: [
                  _buildTag(context, 'Remoto', isCompact),
                  _buildTag(context, 'Full Time', isCompact),
                ],
              ),
              
              // Separación y Salario (diferente manejo en lista vs grilla)
              if (isCompact) ...[
                const Spacer(), 
                const Divider(height: 20),
              ] else if (isMobileList) ...[
                const Divider(height: 20),
              ],
              
              // 3. Salario y Flecha
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '45k - 60k €/año',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w700,
                      fontSize: isCompact ? 15 : 17,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}