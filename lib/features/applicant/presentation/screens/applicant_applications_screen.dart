import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../application/applicant/applicant_applications_view_model.dart';
import '../../../../domain/models/job_application.dart';

class ApplicantApplicationsScreen extends ConsumerWidget {
  const ApplicantApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(applicantApplicationsProvider);
    final notifier = ref.read(applicantApplicationsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Postulaciones'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: RefreshIndicator(
        onRefresh: notifier.refreshApplications,
        child: applicationsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error al cargar postulaciones', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('$err', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: notifier.refreshApplications,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
          data: (applications) {
            if (applications.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.work_off, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('Aún no has aplicado a ninguna oferta'),
                    SizedBox(height: 8),
                    Text('¡Explora y postúlate!', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: applications.length,
              itemBuilder: (context, index) {
                final app = applications[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ApplicationCard(application: app),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------
// WIDGET: Tarjeta de Postulación (mejorada)
// ----------------------------------------------------------------

class ApplicationCard extends StatelessWidget {
  final JobApplication application;

  const ApplicationCard({required this.application, super.key});

  // Mapeo de estado (String → UI)
  (Color, String) _getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case 'enviada':
      case 'submitted':
        return (Colors.blue.shade400, 'Enviada');
      case 'revisada':
      case 'reviewed':
        return (Colors.orange.shade400, 'Revisada');
      case 'entrevista':
      case 'interview':
        return (Colors.green.shade500, 'Entrevista');
      case 'aceptada':
      case 'hired':
        return (Colors.teal.shade600, 'Aceptada');
      case 'rechazada':
      case 'rejected':
        return (Colors.red.shade500, 'Rechazada');
      default:
        return (Colors.grey.shade500, 'Desconocido');
    }
  }

  @override
  Widget build(BuildContext context) {
    final (statusColor, statusText) = _getStatusInfo(application.status);
    final formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(application.appliedAt);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          //Navegar a detalles de postulación
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Detalles de: ${application.jobTitle}')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título + Empresa
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          application.jobTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          application.companyName,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badge de estado
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor, width: 1),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const Divider(height: 24),

              // Fecha + Icono
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Text(
                    'Postulada el $formattedDate',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Acción sutil
              Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}