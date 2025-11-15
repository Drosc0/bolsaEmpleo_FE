import 'package:bolsa_empleo/core/di/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../application/company/company_home_view_model.dart';
import '../../../../application/common/home_state.dart'; 

class CompanyHomeScreen extends ConsumerWidget {
  const CompanyHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authProvider.notifier);
    
    // Observar el estado del ViewModel de la empresa
    final companyState = ref.watch(companyHomeViewModelProvider);
    final companyNotifier = ref.read(companyHomeViewModelProvider.notifier);

    // Cargar ofertas al iniciar la pantalla si aún no se ha hecho
    if (companyState.status == HomeStatus.initial) {
      // Usar addPostFrameCallback para evitar errores de rebuild síncrono
      WidgetsBinding.instance.addPostFrameCallback((_) {
        companyNotifier.loadPostedOffers();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Empresa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: companyNotifier.loadPostedOffers,
            tooltip: 'Recargar Ofertas',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: authNotifier.logout,
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Ofertas de Trabajo Publicadas',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          //Manejo de Estados de la UI
          Expanded(
            child: switch (companyState.status) {
              HomeStatus.loading || HomeStatus.initial => const Center(
                child: CircularProgressIndicator(),
              ),
              HomeStatus.error => Center(
                child: Text('Error al cargar: ${companyState.errorMessage ?? "Desconocido"}'),
              ),
              HomeStatus.loaded => _CompanyOffersList(offers: companyState.data),
            },
          ),
        ],
      ),
    );
  }
}

// Sub-Widget para mostrar la lista de ofertas
class _CompanyOffersList extends StatelessWidget {
  final List<PostedJobOffer> offers;

  const _CompanyOffersList({required this.offers});

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) {
      return const Center(child: Text('No has publicado ninguna oferta aún.'));
    }

    return ListView.builder(
      itemCount: offers.length,
      itemBuilder: (context, index) {
        final offer = offers[index];
        return ListTile(
          title: Text(offer.title),
          subtitle: Text('Aplicaciones: ${offer.totalApplications}'),
          trailing: Chip(
            label: Text('${offer.newApplications} nuevas'),
            backgroundColor: Colors.amber[100],
          ),
          onTap: () {
            // Navegar al detalle de la oferta/aplicaciones
          },
        );
      },
    );
  }
}