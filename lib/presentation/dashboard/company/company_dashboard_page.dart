import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodel/company_dashboard_view_model.dart';
import '../../home/viewmodel/home_view_model.dart';
import '../../../data/repositories/company_repository.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/secure_storage_service.dart';
import 'widgets/edit_company_profile_dialog.dart';
import 'widgets/offer_details_dialog.dart';
import '../../../data/models/job_offer_model.dart';
import '../../../data/models/application_model.dart';

class CompanyDashboardPage extends StatelessWidget {
  const CompanyDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CompanyDashboardViewModel(
        companyRepository: CompanyRepository(
          apiService: ApiService(),
          storageService: SecureStorageService(),
        ),
      ),
      child: const _CompanyDashboardContent(),
    );
  }
}

class _CompanyDashboardContent extends StatelessWidget {
  const _CompanyDashboardContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CompanyDashboardViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Empresa')),
      body: viewModel.state == DashboardState.loading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.state == DashboardState.error
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(viewModel.errorMessage ?? 'Error desconocido'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => viewModel.fetchDashboardData(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : Row(
              children: [
                // COLUMNA 1: Datos de la Empresa y Edición
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    color: Theme.of(context).colorScheme.surface,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            child: Icon(
                              Icons.business,
                              size: 40,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            viewModel.companyProfile?.companyName ?? 'Empresa',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),
                        _ProfileInfoRow(
                          icon: Icons.description,
                          label: 'Descripción',
                          value:
                              viewModel.companyProfile?.description ??
                              'Sin descripción',
                        ),
                        const SizedBox(height: 12),
                        _ProfileInfoRow(
                          icon: Icons.language,
                          label: 'Sitio Web',
                          value:
                              viewModel.companyProfile?.website ??
                              'No especificado',
                        ),
                        const SizedBox(height: 12),
                        _ProfileInfoRow(
                          icon: Icons.location_on,
                          label: 'Ubicación',
                          value:
                              viewModel.companyProfile?.location ??
                              'No especificada',
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => EditCompanyProfileDialog(
                                  profile: viewModel.companyProfile!,
                                  viewModel: viewModel,
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Modificar Datos'),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(width: 1),

                // COLUMNA 2: Gestión de Ofertas
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // FILA 1: Ofertas Recientes y Crear Oferta
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            // Sub-Columna 1: Ofertas Recientes (Resumen)
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Actividad Reciente',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 10),
                                    Expanded(
                                      child: viewModel.recentActivity.isEmpty
                                          ? const Center(
                                              child: Text(
                                                'No hay actividad reciente.',
                                              ),
                                            )
                                          : ListView.builder(
                                              itemCount: viewModel
                                                  .recentActivity
                                                  .length,
                                              itemBuilder: (context, index) {
                                                final item = viewModel
                                                    .recentActivity[index];

                                                if (item is JobOffer) {
                                                  return ListTile(
                                                    leading: CircleAvatar(
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .secondaryContainer,
                                                      child: Icon(
                                                        Icons.work,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSecondaryContainer,
                                                      ),
                                                    ),
                                                    title: Text(item.title),
                                                    subtitle: const Text(
                                                      'Oferta Creada',
                                                    ),
                                                    dense: true,
                                                  );
                                                } else if (item
                                                    is Application) {
                                                  return ListTile(
                                                    leading: CircleAvatar(
                                                      child: Text(
                                                        item
                                                                .applicant
                                                                ?.firstName
                                                                .substring(
                                                                  0,
                                                                  1,
                                                                ) ??
                                                            'U',
                                                      ),
                                                    ),
                                                    title: Text(
                                                      item
                                                              .applicant
                                                              ?.fullName ??
                                                          'Usuario Desconocido',
                                                    ),
                                                    subtitle: Text(
                                                      'Postulación a ${item.jobOffer.title} - ${item.status}',
                                                    ),
                                                    dense: true,
                                                  );
                                                }
                                                return const SizedBox.shrink();
                                              },
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const VerticalDivider(width: 1),
                            // Sub-Columna 2: Formulario Crear Oferta
                            Expanded(
                              child: Card(
                                elevation: 2,
                                margin: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: const _CreateOfferForm(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),

                      // FILA 2: Todas las Ofertas Creadas
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Todas mis Ofertas',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: viewModel.jobOffers.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'No has creado ninguna oferta todavía.',
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: viewModel.jobOffers.length,
                                        itemBuilder: (context, index) {
                                          final offer =
                                              viewModel.jobOffers[index];
                                          return Card(
                                            margin: const EdgeInsets.only(
                                              bottom: 12.0,
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      OfferDetailsDialog(
                                                        offer: offer,
                                                        viewModel: viewModel,
                                                        onStatusChanged: () {
                                                          viewModel
                                                              .fetchDashboardData();
                                                        },
                                                      ),
                                                );
                                              },
                                              child: ListTile(
                                                title: Text(offer.title),
                                                subtitle: Text(
                                                  '${offer.location} - ${offer.salaryRange}',
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _CreateOfferForm extends StatefulWidget {
  const _CreateOfferForm();

  @override
  State<_CreateOfferForm> createState() => _CreateOfferFormState();
}

class _CreateOfferFormState extends State<_CreateOfferForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _salaryController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final viewModel = context.read<CompanyDashboardViewModel>();

    try {
      await viewModel.createOffer({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'location': _locationController.text.trim(),
        'salaryRange': _salaryController.text.trim(),
      });

      // Clear form on success
      _titleController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _salaryController.clear();

      if (mounted) {
        // Recargar las ofertas en el HomeViewModel para que se vean en el menú principal
        context.read<HomeViewModel>().fetchInitialData();
        // Recargar el dashboard para ver la nueva oferta en la actividad reciente
        await viewModel.fetchDashboardData();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Oferta creada exitosamente')),
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nueva Oferta', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              maxLines: 2,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Ubicación',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Campo requerido' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _salaryController,
                    decoration: const InputDecoration(
                      labelText: 'Salario',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Campo requerido' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Crear Oferta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
