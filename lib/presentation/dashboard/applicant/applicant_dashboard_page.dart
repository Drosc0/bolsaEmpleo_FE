import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodel/applicant_dashboard_view_model.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../data/repositories/applications_repository.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/secure_storage_service.dart';
import 'widgets/edit_applicant_profile_dialog.dart';

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

// StatelessWidget que contiene la lógica de la pantalla
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
                              Icons.person,
                              size: 40,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            viewModel.profile?.fullName ?? 'Usuario',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),
                        if (viewModel.profile != null) ...[
                          _ProfileInfoRow(
                            icon: Icons.email,
                            label: 'Email',
                            value: viewModel.profile?.email ?? 'No disponible',
                          ),
                          const SizedBox(height: 12),
                          _ProfileInfoRow(
                            icon: Icons.phone,
                            label: 'Teléfono',
                            value: viewModel.profile?.phone ?? 'No disponible',
                          ),
                          const SizedBox(height: 12),
                          _ProfileInfoRow(
                            icon: Icons.link,
                            label: 'LinkedIn',
                            value:
                                viewModel.profile?.linkedinUrl ??
                                'No disponible',
                          ),
                          const SizedBox(height: 12),
                          _ProfileInfoRow(
                            icon: Icons.work,
                            label: 'Portfolio',
                            value:
                                viewModel.profile?.portfolioUrl ??
                                'No disponible',
                          ),
                        ] else
                          const Text('No se encontró perfil'),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    EditApplicantProfileDialog(
                                      profile: viewModel.profile!,
                                    ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Modificar Datos'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(width: 1),

                // COLUMNA 2: Ofertas Aplicadas (Mayor tamaño)
                Expanded(
                  flex: 2,
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
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sugerencias',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 20),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'No hay sugerencias disponibles.',
                              textAlign: TextAlign.center,
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

class _ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoRow({
    super.key,
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
