import 'package:flutter/material.dart';

import '../../../../data/models/job_offer_model.dart';
import '../../../../data/models/application_model.dart';
import '../viewmodel/company_dashboard_view_model.dart';

class OfferDetailsDialog extends StatefulWidget {
  final JobOffer offer;
  final CompanyDashboardViewModel viewModel;

  const OfferDetailsDialog({
    super.key,
    required this.offer,
    required this.viewModel,
  });

  @override
  State<OfferDetailsDialog> createState() => _OfferDetailsDialogState();
}

class _OfferDetailsDialogState extends State<OfferDetailsDialog> {
  late Future<List<Application>> _applicationsFuture;

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  void _loadApplications() {
    setState(() {
      _applicationsFuture = widget.viewModel.fetchApplicationsForOffer(
        widget.offer.id,
      );
    });
  }

  Future<void> _updateStatus(Application app, String newStatus) async {
    try {
      await widget.viewModel.updateApplicationStatus(app.id, newStatus);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Estado actualizado a $newStatus')),
        );
        _loadApplications(); // Recarga lista
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _showDeleteConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Oferta'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar esta oferta? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await widget.viewModel.deleteOffer(widget.offer.id);
        if (mounted) {
          Navigator.pop(context); // Close details dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Oferta eliminada exitosamente')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  Future<void> _showEditDialog() async {
    final titleController = TextEditingController(text: widget.offer.title);
    final descriptionController = TextEditingController(
      text: widget.offer.description,
    );
    final locationController = TextEditingController(
      text: widget.offer.location,
    );
    final salaryController = TextEditingController(
      text: widget.offer.salaryRange,
    );
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Oferta'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  maxLines: 3,
                  validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                ),
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Ubicación'),
                  validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                ),
                TextFormField(
                  controller: salaryController,
                  decoration: const InputDecoration(labelText: 'Salario'),
                  validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  await widget.viewModel.updateOffer(widget.offer.id, {
                    'title': titleController.text.trim(),
                    'description': descriptionController.text.trim(),
                    'location': locationController.text.trim(),
                    'salaryRange': salaryController.text.trim(),
                  });
                  if (mounted) {
                    Navigator.pop(context); // Close edit dialog
                    Navigator.pop(context); // Close details dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Oferta actualizada exitosamente'),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // La parte de arriba, con el titulo y los botones.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.offer.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _showEditDialog,
                      icon: const Icon(Icons.edit),
                      tooltip: 'Editar Oferta',
                    ),
                    IconButton(
                      onPressed: _showDeleteConfirmation,
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      tooltip: 'Eliminar Oferta',
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),

            // Aqui van los detalles importantes: donde es y cuanto pagan.
            Row(
              children: [
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 4),
                Text(widget.offer.location),
                const SizedBox(width: 16),
                const Icon(Icons.attach_money, size: 16),
                const SizedBox(width: 4),
                Text(widget.offer.salaryRange),
              ],
            ),
            const SizedBox(height: 8),
            Text(widget.offer.description),
            const SizedBox(height: 24),

            // La lista de gente que quiere el trabajo.
            Text(
              'Postulaciones',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Application>>(
                future: _applicationsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final applications = snapshot.data ?? [];

                  if (applications.isEmpty) {
                    return const Center(
                      child: Text('No hay postulaciones para esta oferta.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: applications.length,
                    itemBuilder: (context, index) {
                      final app = applications[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              app.applicant?.firstName.substring(0, 1) ?? 'U',
                            ),
                          ),
                          title: Text(
                            app.applicant?.fullName ?? 'Usuario Desconocido',
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(app.applicant?.email ?? 'Sin email'),
                              const SizedBox(height: 4),
                              Text('Estado: ${app.status}'),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (status) => _updateStatus(app, status),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'PENDING',
                                child: Text('Pendiente'),
                              ),
                              const PopupMenuItem(
                                value: 'REVIEWING',
                                child: Text('En Revisión'),
                              ),
                              const PopupMenuItem(
                                value: 'ACCEPTED',
                                child: Text('Aceptado'),
                              ),
                              const PopupMenuItem(
                                value: 'REJECTED',
                                child: Text('Rechazado'),
                              ),
                            ],
                            child: Chip(
                              label: Text(app.status),
                              avatar: const Icon(Icons.arrow_drop_down),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
