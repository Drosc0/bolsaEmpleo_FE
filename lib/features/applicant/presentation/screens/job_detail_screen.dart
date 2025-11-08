import 'package:bolsa_empleo/application/applicant/job_apply_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha
// Importamos los ViewModels y Estados necesarios
import '../../../../application/applicant/job_apply_view_model.dart';
import '../../../job_offers/domain/job_offer.dart';

class JobDetailScreen extends ConsumerWidget {
  final JobOffer offer;

  const JobDetailScreen({super.key, required this.offer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Observar el estado de la acción de postulación
    final applyState = ref.watch(jobApplyViewModelProvider);
    final applyNotifier = ref.read(jobApplyViewModelProvider.notifier);
    
    // Formateador de fecha
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    
    // Formateador de salario
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'es_ES', // O la localización que uses
      symbol: '\$',
      decimalDigits: 0,
    );


    // 2. Escuchar el resultado de la postulación
    ref.listen<JobApplyState>(jobApplyViewModelProvider, (previous, next) {
      final snackBar = ScaffoldMessenger.of(context);

      if (next.status == ApplicationActionStatus.success) {
        snackBar.showSnackBar(
          const SnackBar(
            content: Text('🎉 ¡Postulación enviada con éxito!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (next.status == ApplicationActionStatus.failure && next.errorMessage != null) {
        snackBar.showSnackBar(
          SnackBar(
            content: Text('❌ Error al postular: ${next.errorMessage!}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    final isSubmitting = applyState.status == ApplicationActionStatus.submitting;
    final isApplied = applyState.status == ApplicationActionStatus.success;

    // Generar el rango salarial formateado
    final formattedSalary = '${currencyFormatter.format(offer.minSalary)} - ${currencyFormatter.format(offer.maxSalary)}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Oferta'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🏷️ Título de la Oferta
            Text(
              offer.title,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // 🏢 Empresa y Ubicación (USANDO 'company')
            Text(
              '${offer.company} | ${offer.location}', 
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey[700]),
            ),
            const Divider(height: 32),

            // 📝 Descripción
            Text(
              'Descripción del Puesto',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(offer.description),
            const Divider(height: 32),

            // 💰 Detalles y Salario
            Text(
              'Detalles Clave',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // USANDO 'contractType' (Asegúrate de agregarlo a tu modelo)
            _buildDetailRow(context, Icons.work, 'Tipo de Contrato:', offer.contractType), 
            // USANDO RANGO SALARIAL
            _buildDetailRow(context, Icons.attach_money, 'Salario Estimado:', formattedSalary), 
            // USANDO 'postedDate' y Formateador
            _buildDetailRow(context, Icons.schedule, 'Publicado:', formatter.format(offer.postedDate)), 
          ],
        ),
      ),
      // 🚀 Botón de Postulación
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            backgroundColor: isApplied ? Colors.grey : Theme.of(context).colorScheme.primary,
          ),
          onPressed: isSubmitting || isApplied ? null : () {
            applyNotifier.applyForJob(offer.id); 
          },
          child: isSubmitting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : isApplied
                  ? const Text('Ya Postulado ✅', style: TextStyle(fontSize: 18, color: Colors.white))
                  : const Text('Aplicar a la Oferta', style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }

  // Widget auxiliar para mostrar detalles en filas
  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          Flexible(child: Text(value)),
        ],
      ),
    );
  }
}