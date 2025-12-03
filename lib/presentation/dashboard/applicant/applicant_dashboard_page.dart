import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodel/applicant_dashboard_view_model.dart';
import '../../../data/models/job_offer_model.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../data/repositories/applications_repository.dart';
import '../../../data/repositories/job_repository.dart';
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
        jobRepository: JobRepository(
          apiService: ApiService(),
          storageService: SecureStorageService(),
        ),
      ),
      child: const _ApplicantDashboardContent(),
    );
  }
}

// Aqui empieza la fiesta. La pantalla principal del candidato.
class _ApplicantDashboardContent extends StatelessWidget {
  const _ApplicantDashboardContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ApplicantDashboardViewModel>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
            : LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 600) {
                    return _DesktopLayout(viewModel: viewModel);
                  } else {
                    return _MobileLayout(viewModel: viewModel);
                  }
                },
              ),
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final ApplicantDashboardViewModel viewModel;

  const _DesktopLayout({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // COLUMNA 1: Quien soy yo? Mi foto y mis datos.
        Expanded(flex: 1, child: _ProfileSection(viewModel: viewModel)),
        const VerticalDivider(width: 1),

        // COLUMNA 2: Lo importante. Las ofertas y mis candidaturas.
        Expanded(flex: 2, child: _ApplicationsSection(viewModel: viewModel)),
        const VerticalDivider(width: 1),

        // COLUMNA 3: Mis skills. Soy un crack y aqui lo demuestro.
        Expanded(flex: 1, child: _SkillsSection(viewModel: viewModel)),
      ],
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final ApplicantDashboardViewModel viewModel;

  const _MobileLayout({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // SECCION 1: Perfil (Full width)
          _ProfileSection(viewModel: viewModel),
          const Divider(height: 1),

          // SECCION 2: Aplicaciones y Ofertas
          // Le damos una altura fija para que el TabBarView funcione bien dentro del scroll
          SizedBox(
            height: 600,
            child: _ApplicationsSection(viewModel: viewModel),
          ),
          const Divider(height: 1),

          // SECCION 3: Skills
          SizedBox(height: 400, child: _SkillsSection(viewModel: viewModel)),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final ApplicantDashboardViewModel viewModel;

  const _ProfileSection({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // el circulito clasico
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              // icono de personita gris
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
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
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
              value:
                  // to be or not to be
                  // buenu lo puse por si no tiene pero se va a dar el caso
                  viewModel.profile?.email ?? 'No disponible',
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
              value: viewModel.profile?.linkedinUrl ?? 'No disponible',
            ),
            const SizedBox(height: 12),
            _ProfileInfoRow(
              icon: Icons.work,
              label: 'Portfolio',
              value: viewModel.profile?.portfolioUrl ?? 'No disponible',
            ),
          ] else
            const Text('No se encontró perfil'),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => EditApplicantProfileDialog(
                    profile: viewModel.profile!,
                    viewModel: viewModel,
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Modificar Datos'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ApplicationsSection extends StatelessWidget {
  final ApplicantDashboardViewModel viewModel;

  const _ApplicationsSection({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Theme.of(context).colorScheme.surface,
          // va en dos pestañitas pa que sea mas chuchipiruli
          child: const TabBar(
            tabs: [
              Tab(text: 'Mis Candidaturas'),
              Tab(text: 'Ofertas Disponibles'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            children: [
              // Tab 1: Donde me he apuntado ya.
              viewModel.applications.isEmpty
                  // pro si aun no has encontrado tu puesto idilico
                  ? const Center(
                      child: Text('No has aplicado a ninguna oferta aún.'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: viewModel.applications.length,
                      itemBuilder: (context, index) {
                        final app = viewModel.applications[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12.0),
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
              // Tab 2: Ofertas frescas. A por ellas!
              viewModel.jobOffers.isEmpty
                  // por si las empresas no quieren a nadie
                  ? const Center(child: Text('No hay ofertas disponibles.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: viewModel.jobOffers.length,
                      itemBuilder: (context, index) {
                        final offer = viewModel.jobOffers[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          child: InkWell(
                            onTap: () =>
                                _showOfferDetails(context, offer, viewModel),
                            child: ListTile(
                              title: Text(offer.title),
                              subtitle: Text(
                                '${offer.companyName} - ${offer.location}',
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  _applyToOffer(context, viewModel, offer.id);
                                },
                                child: const Text('Postularme'),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SkillsSection extends StatelessWidget {
  final ApplicantDashboardViewModel viewModel;

  const _SkillsSection({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila 1: Experiencia
          Text('Experiencia', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Expanded(
            flex: 1,
            child: viewModel.profile?.experience.isEmpty ?? true
                // por si nunca hiciste nada ;)
                ? const Center(child: Text('Sin experiencia registrada'))
                : ListView.builder(
                    itemCount: viewModel.profile!.experience.length,
                    itemBuilder: (context, index) {
                      final exp = viewModel.profile!.experience[index];
                      return Card(
                        child: ListTile(
                          title: Text(exp.title),
                          subtitle: Text(exp.company),
                          dense: true,
                        ),
                      );
                    },
                  ),
          ),
          const Divider(),
          // Fila 2: Skills
          Text('Habilidades', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Expanded(
            flex: 1,
            child: viewModel.profile?.skills.isEmpty ?? true
                // por si no eres MacGuiver
                ? const Center(child: Text('Sin habilidades registradas'))
                : Wrap(
                    spacing: 8,
                    children: viewModel.profile!.skills
                        .map((skill) => Chip(label: Text(skill.name)))
                        .toList(),
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

void _showOfferDetails(
  BuildContext context,
  JobOffer offer,
  ApplicantDashboardViewModel viewModel,
) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(offer.title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Empresa: ${offer.companyName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Ubicación: ${offer.location}'),
            const SizedBox(height: 8),
            const Text(
              'Descripción:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(offer.description),
            const SizedBox(height: 8),
            Text('Salario: ${offer.salaryRange}'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            _applyToOffer(context, viewModel, offer.id);
          },
          child: const Text('Postularme'),
        ),
      ],
    ),
  );
}

void _applyToOffer(
  BuildContext context,
  ApplicantDashboardViewModel viewModel,
  int offerId,
) async {
  try {
    await viewModel.applyToOffer(offerId);
    // ahora tomate una michelada y a esperar
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Te has postulado exitosamente')),
      );
    }
  } catch (e) {
    // por si la plataforma ya te las tira, mejor busca otra!!
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al postular: $e')));
    }
  }
}
