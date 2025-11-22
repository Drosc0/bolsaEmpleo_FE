import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'company_dashboard_view_model.dart';
import '../../../data/repositories/company_repository.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/secure_storage_service.dart';

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
                    color: Colors.blue[50],
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Perfil de Empresa',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 20),
                        if (viewModel.companyProfile != null) ...[
                          Text(
                            'Empresa: ${viewModel.companyProfile!.companyName}',
                          ),
                          if (viewModel.companyProfile!.description != null)
                            Text(
                              'Descripción: ${viewModel.companyProfile!.description}',
                            ),
                          if (viewModel.companyProfile!.website != null)
                            Text('Web: ${viewModel.companyProfile!.website}'),
                          if (viewModel.companyProfile!.location != null)
                            Text(
                              'Ubicación: ${viewModel.companyProfile!.location}',
                            ),
                        ] else
                          const Text('No se encontró perfil de empresa'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Navegar a editar perfil
                          },
                          child: const Text('Modificar Datos'),
                        ),
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
                                      'Resumen Reciente',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 10),
                                    Expanded(
                                      child: viewModel.jobOffers.isEmpty
                                          ? const Center(
                                              child: Text(
                                                'No hay ofertas recientes.',
                                              ),
                                            )
                                          : ListView.builder(
                                              itemCount: viewModel.jobOffers
                                                  .take(3)
                                                  .length,
                                              itemBuilder: (context, index) {
                                                final offer =
                                                    viewModel.jobOffers[index];
                                                return ListTile(
                                                  title: Text(offer.title),
                                                  subtitle: Text(
                                                    offer.location,
                                                  ),
                                                  dense: true,
                                                );
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
                              child: Container(
                                color: Colors.green[50],
                                padding: const EdgeInsets.all(16.0),
                                child: const _CreateOfferForm(),
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
                                            child: ListTile(
                                              title: Text(offer.title),
                                              subtitle: Text(
                                                '${offer.location} - ${offer.salaryRange}',
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
  String _contractType = 'Tiempo completo';

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
        'contractType': _contractType,
      });

      // Clear form on success
      _titleController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _salaryController.clear();

      if (mounted) {
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
            const SizedBox(height: 10),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Ubicación',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _salaryController,
              decoration: const InputDecoration(
                labelText: 'Rango Salarial',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _contractType,
              decoration: const InputDecoration(
                labelText: 'Tipo de contrato',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'jornada completa',
                  child: Text('jornada completa'),
                ),
                DropdownMenuItem(
                  value: 'Media jornada',
                  child: Text('Media jornada'),
                ),
                DropdownMenuItem(value: 'Freelance', child: Text('Freelance')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _contractType = value);
                }
              },
            ),
            const SizedBox(height: 20),
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
