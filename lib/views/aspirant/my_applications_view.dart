import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viemodels/my_applications_view_model.dart';
import '../../models/application.dart';
import '../../models/job_offer.dart'; // Necesario para acceder a los detalles de la oferta

class MyApplicationsView extends StatelessWidget {
  const MyApplicationsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos ChangeNotifierProvider para inyectar y gestionar el estado
    return ChangeNotifierProvider(
      create: (_) {
        final vm = MyApplicationsViewModel();
        vm.fetchMyApplications();
        return vm;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Mis Postulaciones')),
        body: Consumer<MyApplicationsViewModel>(
          builder: (context, applicationsVM, child) {
            if (applicationsVM.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (applicationsVM.errorMessage != null) {
              return Center(child: Text(applicationsVM.errorMessage!));
            }

            if (applicationsVM.applications.isEmpty) {
              return const Center(
                child: Text('Aún no te has postulado a ninguna oferta.', style: TextStyle(fontSize: 16)),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: applicationsVM.applications.length,
              itemBuilder: (context, index) {
                final application = applicationsVM.applications[index];
                return ApplicationCard(application: application);
              },
            );
          },
        ),
      ),
    );
  }
}

// --- Widget Auxiliar para la Tarjeta de Postulación ---

class ApplicationCard extends StatelessWidget {
  final Application application;

  const ApplicationCard({required this.application, super.key});
  
  // Mapea el estado a un color para la UI
  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.accepted:
        return Colors.green;
      case ApplicationStatus.reviewed:
        return Colors.blue;
      case ApplicationStatus.rejected:
        return Colors.red;
      case ApplicationStatus.withdrawn:
        return Colors.grey;
      case ApplicationStatus.pending:
      default:
        return Colors.orange;
    }
  }

  // Mapea el estado a un icono para la UI
  IconData _getStatusIcon(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.accepted:
        return Icons.check_circle;
      case ApplicationStatus.reviewed:
        return Icons.visibility;
      case ApplicationStatus.rejected:
        return Icons.cancel;
      case ApplicationStatus.withdrawn:
        return Icons.remove_circle;
      case ApplicationStatus.pending:
      default:
        return Icons.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    final offer = application.jobOffer;
    final statusColor = _getStatusColor(application.status);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      child: ListTile(
        leading: Icon(_getStatusIcon(application.status), color: statusColor, size: 30),
        title: Text(offer.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Empresa: ${offer.companyName}'),
            Text('Ubicación: ${offer.location}'),
            const SizedBox(height: 4),
            Text(
              'Estado: ${application.status.name.toUpperCase()}', 
              style: TextStyle(color: statusColor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        trailing: Text(
          '${application.appliedAt.toLocal().toString().split(' ')[0]}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        onTap: () {
          // ⚠️ Opcional: Navegar a una vista de detalles de la postulación 
          // que muestre los comentarios (application.comments) de la empresa.
        },
      ),
    );
  }
}