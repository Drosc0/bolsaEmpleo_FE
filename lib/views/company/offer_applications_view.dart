import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viemodels/offer_applications_view_model.dart';
import '../../models/application.dart';
import '../../models/aspirant_profile.dart';
import '../../views/aspirant/aspirant_profile_details_view.dart'; 

class OfferApplicationsView extends StatelessWidget {
  final int offerId;
  final String offerTitle;

  const OfferApplicationsView({
    required this.offerId,
    required this.offerTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Inyectar el ViewModel necesario para esta pantalla
    return ChangeNotifierProvider(
      create: (_) {
        final vm = OfferApplicationsViewModel(offerId: offerId, offerTitle: offerTitle);
        vm.fetchApplications();
        return vm;
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Postulantes para $offerTitle')),
        body: Consumer<OfferApplicationsViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (vm.errorMessage != null) {
              return Center(child: Text(vm.errorMessage!));
            }

            if (vm.applications.isEmpty) {
              return const Center(child: Text('Aún no hay postulaciones para esta oferta.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: vm.applications.length,
              itemBuilder: (context, index) {
                final application = vm.applications[index];
                final aspirantProfile = application.aspirantProfile; 
                
                // 🛑 CORRECCIÓN DE ERROR NULO: Omitir si no hay perfil.
                if (aspirantProfile == null) {
                  return const SizedBox.shrink(); 
                }
                
                return ApplicantCard(
                  application: application,
                  aspirantProfile: aspirantProfile, // Garantizamos que no es nulo aquí
                  onUpdateStatus: (newStatus) => _showStatusUpdateDialog(context, vm, application, newStatus),
                  onViewProfile: () => _viewApplicantProfile(context, aspirantProfile),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // --- Lógica de la Vista ---

  // 1. Navega a la vista detallada del perfil (CV)
  void _viewApplicantProfile(BuildContext context, AspirantProfile profile) {
    // ✅ Navegación a la vista dedicada para el CV
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AspirantProfileDetailsView(profile: profile),
      ),
    );
  }

  // 2. Muestra el diálogo de actualización de estado
  void _showStatusUpdateDialog(
    BuildContext context,
    OfferApplicationsViewModel vm,
    Application application,
    ApplicationStatus initialStatus,
  ) {
    // 🛑 CORRECCIÓN DE ERROR NULO: Usamos el nombre seguro del aspirante
    final aspirantProfile = application.aspirantProfile;
    final applicantName = aspirantProfile?.name ?? 'Candidato Desconocido'; 
      
    ApplicationStatus? selectedStatus = initialStatus;
    TextEditingController commentsController = TextEditingController(text: application.comments);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Actualizar Estado de $applicantName'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<ApplicationStatus>(
                    decoration: const InputDecoration(labelText: 'Nuevo Estado'),
                    value: selectedStatus,
                    items: ApplicationStatus.values.map((status) {
                      // Excluye estados no aptos para ser cambiados por la empresa
                      if (status == ApplicationStatus.withdrawn || status == ApplicationStatus.pending) {
                          return null; 
                      }
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status.name.toUpperCase()),
                      );
                    }).whereType<DropdownMenuItem<ApplicationStatus>>().toList(),
                    onChanged: (ApplicationStatus? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedStatus = newValue;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: commentsController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Comentarios Internos (Opcional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            ElevatedButton(
              onPressed: selectedStatus == null ? null : () async {
                Navigator.of(dialogContext).pop();
                
                final success = await vm.updateApplicationStatus(
                  application.id,
                  selectedStatus!,
                  comments: commentsController.text,
                );
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? 'Estado actualizado.' : vm.errorMessage!),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}

// --- Widget Auxiliar para el Candidato ---
class ApplicantCard extends StatelessWidget {
  final Application application;
  final AspirantProfile aspirantProfile;
  final Function(ApplicationStatus) onUpdateStatus;
  final VoidCallback onViewProfile;

  const ApplicantCard({
    required this.application,
    required this.aspirantProfile,
    required this.onUpdateStatus,
    required this.onViewProfile,
    super.key,
  });
  
  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.accepted: return Colors.green;
      case ApplicationStatus.reviewed: return Colors.blue;
      case ApplicationStatus.rejected: return Colors.red;
      case ApplicationStatus.pending: return Colors.grey;
      case ApplicationStatus.interview: return Colors.deepPurple;
      case ApplicationStatus.withdrawn: return Colors.brown;
      }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(application.status);
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.2),
          child: Icon(Icons.person, color: statusColor),
        ),
        title: Text(aspirantProfile.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(aspirantProfile.email),
            Text('Postuló el: ${application.appliedAt.toLocal().toString().split(' ')[0]}'),
            Text('Estado: ${application.status.name.toUpperCase()}', style: TextStyle(color: statusColor, fontWeight: FontWeight.w600)),
          ],
        ),
        trailing: PopupMenuButton<ApplicationStatus>(
          onSelected: onUpdateStatus,
          itemBuilder: (BuildContext context) {
            return ApplicationStatus.values.where((s) => s != ApplicationStatus.pending && s != ApplicationStatus.withdrawn)
                .map((ApplicationStatus status) {
              return PopupMenuItem<ApplicationStatus>(
                value: status,
                child: Text(status.name.toUpperCase(), style: TextStyle(color: _getStatusColor(status))),
              );
            }).toList();
          },
        ),
        onTap: onViewProfile, // Ver el perfil completo (CV)
      ),
    );
  }
}