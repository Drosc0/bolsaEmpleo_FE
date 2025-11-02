import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viemodels/offer_details_view_model.dart';
import '../../models/job_offer.dart';

class OfferDetailsView extends StatelessWidget {
  final int offerId;
  const OfferDetailsView({required this.offerId, super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos ChangeNotifierProvider.value para inyectar el ViewModel necesario para esta pantalla
    return ChangeNotifierProvider(
      create: (_) {
        final vm = OfferDetailsViewModel();
        vm.fetchOfferDetails(offerId);
        return vm;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Detalles de la Oferta')),
        body: Consumer<OfferDetailsViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (vm.errorMessage != null) {
              return Center(child: Text(vm.errorMessage!));
            }

            if (vm.offer == null) {
              return const Center(child: Text('Oferta no disponible.'));
            }

            return _buildOfferContent(context, vm, vm.offer!);
          },
        ),
      ),
    );
  }

  Widget _buildOfferContent(
    BuildContext context,
    OfferDetailsViewModel vm,
    JobOffer offer,
  ) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(offer.title, style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 8),
                Text(offer.companyName, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                
                _buildDetailRow(Icons.location_on, offer.location),
                _buildDetailRow(Icons.attach_money, '\$${offer.salary.toStringAsFixed(0)}'),
                _buildDetailRow(Icons.calendar_today, 'Publicada: ${offer.postedAt.toLocal().toString().split(' ')[0]}'),
                
                const Divider(height: 30),
                Text('Descripción', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(offer.description),

                // Requisitos (si están disponibles)
                if (offer.requirements != null && offer.requirements!.isNotEmpty) ...[
                  const Divider(height: 30),
                  Text('Requisitos Clave', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...offer.requirements!.map((req) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('• $req'),
                  )).toList(),
                ],
              ],
            ),
          ),
        ),
        
        // --- Botón de Postulación Fijo en la Parte Inferior ---
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: vm.isApplying
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton.icon(
                  onPressed: () => _handleApply(context, vm),
                  icon: const Icon(Icons.send),
                  label: const Text('Postularme Ahora'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50), // Botón de ancho completo
                  ),
                ),
        ),
      ],
    );
  }

  // --- Widgets Auxiliares ---
  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
  
  // --- Lógica de Postulación ---
  void _handleApply(BuildContext context, OfferDetailsViewModel vm) async {
    await vm.applyToOffer();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.successMessage ?? vm.errorMessage ?? 'Ocurrió un problema.'),
          backgroundColor: vm.successMessage != null ? Colors.green : Colors.red,
        ),
      );
      
      // Opcional: Deshabilitar el botón de postulación si fue exitoso
    }
  }
}