import 'package:bolsa_empleo/application/applicant/profile/user_profile_preview.dart';
import 'package:bolsa_empleo/core/di/providers.dart' hide userHomeViewModelProvider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bolsa_empleo/application/auth/auth_provider.dart';
import 'package:bolsa_empleo/application/applicant/user_home_view_model.dart';
import 'package:bolsa_empleo/application/common/home_state.dart';
import 'package:bolsa_empleo/presetation/shared/widgets/responsive_layout.dart';

class UserHomeScreen extends ConsumerWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authProvider.notifier);
    final userState = ref.watch(userHomeViewModelProvider);
    final userNotifier = ref.read(userHomeViewModelProvider.notifier);

    if (userState.status == HomeStatus.initial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        userNotifier.loadRecommendedOffers();
      });
    }

    return ResponsiveLayout(
      mobile: _MobileView(authNotifier: authNotifier),
      web: _WebView(authNotifier: authNotifier),
    );
  }
}

class _WebView extends StatelessWidget {
  final AuthNotifier authNotifier;
  const _WebView({required this.authNotifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil y Aplicaciones'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: authNotifier.logout),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(flex: 25, child: CurriculumColumn()),
          const VerticalDivider(width: 1),
          const Expanded(flex: 50, child: AppliedOffersColumn()),
          const VerticalDivider(width: 1),
          const Expanded(flex: 25, child: SuggestedOffersColumn()),
        ],
      ),
    );
  }
}

class _MobileView extends StatelessWidget {
  final AuthNotifier authNotifier;
  const _MobileView({required this.authNotifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [IconButton(icon: const Icon(Icons.logout), onPressed: authNotifier.logout)],
      ),
      body: const Center(child: Text('Vista Móvil - Pendiente')),
    );
  }
}

// COLUMNA 1: CURRICULUM (con perfil básico)
class CurriculumColumn extends ConsumerWidget {
  const CurriculumColumn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userProfilePreviewProvider).when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (user) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Mi CV', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            Text('Nombre: ${user['name'] ?? 'No disponible'}'),
            Text('Email: ${user['email'] ?? 'No disponible'}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/profile'),
              child: const Text('Editar Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}

class AppliedOffersColumn extends ConsumerWidget {
  const AppliedOffersColumn({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(child: Text('Pendiente: fetchAppliedOffers()')),
    );
  }
}

class SuggestedOffersColumn extends ConsumerWidget {
  const SuggestedOffersColumn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userHomeViewModelProvider);
    final userNotifier = ref.read(userHomeViewModelProvider.notifier);

    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Ofertas Sugeridas', style: TextStyle(fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.refresh, size: 20), onPressed: userNotifier.loadRecommendedOffers),
            ],
          ),
          const Divider(),
          Expanded(
            child: switch (userState.status) {
              HomeStatus.loading || HomeStatus.initial => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              HomeStatus.error => Center(child: Text(userState.errorMessage ?? 'Error', style: const TextStyle(color: Colors.red))),
              HomeStatus.loaded => userState.data.isEmpty
                  ? const Center(child: Text('No hay ofertas'))
                  : ListView.builder(
                      itemCount: userState.data.length,
                      itemBuilder: (_, i) {
                        final o = userState.data[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(o.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            subtitle: Text('${o.company} - ${o.location}', style: const TextStyle(fontSize: 12)),
                            trailing: const Icon(Icons.chevron_right, size: 16),
                            dense: true,
                            onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(o.title))),
                          ),
                        );
                      },
                    ),
            },
          ),
        ],
      ),
    );
  }
}