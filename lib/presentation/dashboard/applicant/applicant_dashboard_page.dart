import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'applicant_dashboard_view_model.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../data/repositories/applications_repository.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/secure_storage_service.dart';

class ApplicantDashboardPage extends StatelessWidget {
  const ApplicantDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ApplicantDashboardViewModel(
        profileRepository: ProfileRepository(
          apiService: ApiService(),
          storageService: SecureStorageService(),
        ),
        applicationsRepository: ApplicationsRepository(
          apiService: ApiService(),
          storageService: SecureStorageService(),
        ),
      ),
      child: const _ApplicantDashboardContent(),
    );
  }
}

class _ApplicantDashboardContent extends StatelessWidget {
  const _ApplicantDashboardContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ApplicantDashboardViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Aspirante')),
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
                // COLUMNA 1: Datos del Perfil y Edición
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.blue[50],
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mi Perfil',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 20),
                        if (viewModel.profile != null) ...[
                          Text('Nombre: ${viewModel.profile!.fullName}'),
                          if (viewModel.profile!.phone != null)
                            Text('Teléfono: ${viewModel.profile!.phone}'),
                          if (viewModel.profile!.linkedinUrl != null)
                            Text('LinkedIn: ${viewModel.profile!.linkedinUrl}'),
                          if (viewModel.profile!.portfolioUrl != null)
                            Text(
                              'Portfolio: ${viewModel.profile!.portfolioUrl}',
                            ),
                        ] else
                          const Text('No se encontró perfil'),
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

                // COLUMNA 2: Ofertas Aplicadas
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mis Candidaturas',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: viewModel.applications.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No has aplicado a ninguna oferta aún.',
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: viewModel.applications.length,
                                  itemBuilder: (context, index) {
                                    final app = viewModel.applications[index];
                                    return Card(
                                      margin: const EdgeInsets.only(
                                        bottom: 12.0,
                                      ),
                                      child: ListTile(
                                        title: Text(app.jobOffer.title),
                                        subtitle: Text('Estado: ${app.status}'),
                                        trailing: Text(
                                          '${app.appliedAt.day}/${app.appliedAt.month}/${app.appliedAt.year}',
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
                const VerticalDivider(width: 1),

                // COLUMNA 3: Sugerencias
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.orange[50],
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sugerencias para ti',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 20),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'No hay sugerencias disponibles por el momento.',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
