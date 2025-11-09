import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../application/applicant/applicant_applications_view_model.dart';
import '../../../../domain/models/job_application.dart';

class ApplicantApplicationsScreen extends ConsumerWidget {
  const ApplicantApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observar el estado de las postulaciones
    final applicationsAsync = ref.watch(applicantApplicationsProvider);
    final notifier = ref.read(applicantApplicationsProvider.notifier);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Postulaciones'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: RefreshIndicator(
        onRefresh: notifier.refreshApplications, // Permite recargar
        child: applicationsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Text('Error al cargar: $err'),
          ),
          data: (applications) {
            if (applications.isEmpty) {
              return const Center(child: Text('Aún no has aplicado a ninguna oferta.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: applications.length,
              itemBuilder: (context, index) {
                final app = applications[index];
                return ApplicationCard(application: app);
              },
            );
          },
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------
// WIDGET AUXILIAR: Tarjeta de Postulación
// ----------------------------------------------------------------

class ApplicationCard extends StatelessWidget {
  final JobApplication application;

  const ApplicationCard({required this.application, super.key});
  
  // Función para obtener el color y texto del estado
  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.submitted: return Colors.blue.shade300;
      case ApplicationStatus.reviewed: return Colors.orange.shade300;
      case ApplicationStatus.interview: return Colors.green.shade400;
      case ApplicationStatus.rejected: return Colors.red.shade400;
      default: return Colors.grey;
    }
  }

  String _getStatusText(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.submitted: return 'Enviada';
      case ApplicationStatus.reviewed: return 'Revisada';
      case ApplicationStatus.interview: return 'Entrevista';
      case ApplicationStatus.rejected: return 'Rechazada';
      default: return 'Desconocido';
    }
  }

  // En una aplicación real, aquí debería buscar el título del JobOffer usando el jobOfferId
  // solo mostraremos el ID de momento
  String _getJobTitle(String jobOfferId) {
    // Simulación:
    if (jobOfferId == '1') return 'Senior Flutter Developer';
    if (jobOfferId == '2') return 'Product Manager';
    if (jobOfferId == '3') return 'Junior UX/UI Designer';
    return 'Oferta ID: $jobOfferId'; 
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(application.status);
    final statusText = _getStatusText(application.status);
    final formattedDate = DateFormat('dd MMM yyyy').format(application.appliedAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor,
          child: Icon(Icons.work_history, color: Colors.white),
        ),
        title: Text(
          _getJobTitle(application.jobOfferId),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Postulada el: $formattedDate'),
            const SizedBox(height: 4),
            Text(
              'Estado: $statusText',
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TO-DO: Navegar a una pantalla de detalles de la postulación
        },
      ),
    );
  }
}