import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../application/job_offers_provider.dart';
import '../../domain/job_offer.dart';

class JobOffersListScreen extends ConsumerWidget {
  const JobOffersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersState = ref.watch(jobOffersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ofertas Laborales'),
      ),
      body: offersState.when(
        // Estado de Carga
        loading: () => const Center(child: CircularProgressIndicator()),
        
        // Estado de Error
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Error al cargar las ofertas: ${err.toString()}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
        
        // Estado de Datos (Éxito)
        data: (offers) {
          // Si no hay ofertas
          if (offers.isEmpty) {
            return const Center(child: Text('No se encontraron ofertas.'));
          }

          // Usamos LayoutBuilder para el diseño responsivo basado en el ancho
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              // 1. Diseño Móvil (Lista)
              if (width < kMobileBreakpoint) {
                return _MobileListView(offers: offers);
              } 
              // 2. Diseño Tablet (Grilla de 2 Columnas)
              else if (width >= kMobileBreakpoint && width < kTabletBreakpoint) {
                return _TabletGridView(offers: offers);
              } 
              // 3. Diseño Web/Escritorio (Grilla de 3 Columnas para 1440px+)
              else {
                return _WebGridView(offers: offers);
              }
            },
          );
        },
      ),
    );
  }
}

// --- 1. VISTA MÓVIL (ListView) ---
class _MobileListView extends StatelessWidget {
  final List<JobOffer> offers;

  const _MobileListView({required this.offers});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        final offer = offers[index];
        // Utilizamos la misma tarjeta de diseño pero adaptada a List
        return JobOfferCard(offer: offer, isList: true);
      },
    );
  }
}

// --- 2. VISTA TABLET (GridView - 2 Columnas) ---
class _TabletGridView extends StatelessWidget {
  final List<JobOffer> offers;

  const _TabletGridView({required this.offers});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Dos columnas para tablet
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1.5, // Altura de las tarjetas
        ),
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return JobOfferCard(offer: offer, isGrid: true);
        },
      ),
    );
  }
}

// --- 3. VISTA WEB (GridView - 3 Columnas) ---
class _WebGridView extends StatelessWidget {
  final List<JobOffer> offers;

  const _WebGridView({required this.offers});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Tres columnas para pantallas grandes
          crossAxisSpacing: 30,
          mainAxisSpacing: 30,
          childAspectRatio: 1.2, // Tarjetas más compactas en web (1440px+)
        ),
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return JobOfferCard(offer: offer, isGrid: true);
        },
      ),
    );
  }
}

// --- Tarjeta de Oferta Reutilizable (Adaptada) ---
class JobOfferCard extends StatelessWidget {
  final JobOffer offer;
  final bool isList;
  final bool isGrid;

  const JobOfferCard({
    super.key,
    required this.offer,
    this.isList = false,
    this.isGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompact = isGrid; // La grilla es más compacta que la lista

    return Card(
      elevation: isList ? 2 : 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // La lista usa margin, la grilla no (lo maneja GridView spacing)
      margin: isList ? const EdgeInsets.only(bottom: 12) : EdgeInsets.zero,
      
      child: InkWell(
        onTap: () {
          // Navegación al detalle de la oferta
          context.go('/offers/${offer.id}'); 
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Título y Compañía
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isCompact ? 16 : 18,
                    ),
                    maxLines: isCompact ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    offer.company,
                    style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7), fontSize: isCompact ? 13 : 14),
                  ),
                ],
              ),

              // Detalles y Salario
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ubicación y Tipo
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(offer.location, style: const TextStyle(fontSize: 13)),
                      const Spacer(),
                      _buildTag(context, 'Full Time', isCompact),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Salario
                  Text(
                    '${offer.minSalary}k - ${offer.maxSalary}k €',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: isCompact ? 15 : 17,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget de utilidad para las etiquetas
  Widget _buildTag(BuildContext context, String text, bool isCompact) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isCompact ? 6 : 8, vertical: isCompact ? 3 : 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: isCompact ? 10 : 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}