import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../application/auth/auth_provider.dart';
import '../../../../application/applicant/user_home_view_model.dart';
import '../../../../application/common/home_state.dart';
import '../../../shared/presentation/widgets/responsive_layout.dart';

class UserHomeScreen extends ConsumerWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authProvider.notifier);

    // Cargar las ofertas recomendadas al iniciar la pantalla
    final userState = ref.watch(userHomeViewModelProvider);
    final userNotifier = ref.read(userHomeViewModelProvider.notifier);
    
    if (userState.status == HomeStatus.initial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        userNotifier.loadRecommendedOffers();
      });
    }

    // Usar ResponsiveLayout para adaptar el diseño
    return ResponsiveLayout(
      mobile: _MobileView(authNotifier: authNotifier),
      web: _WebView(authNotifier: authNotifier),
    );
  }
}

// -----------------------------------------
// Sub-Widget para la vista WEB (3 Columnas)
// -----------------------------------------
class _WebView extends StatelessWidget {
  final AuthNotifier authNotifier;

  const _WebView({required this.authNotifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil y Aplicaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: authNotifier.logout,
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Columna 1: Info del Curriculum (25%)
          const Expanded(flex: 25, child: CurriculumColumn()),
          const VerticalDivider(width: 1),
          // Columna 2: Ofertas a las que se ha postulado (50%)
          const Expanded(flex: 50, child: AppliedOffersColumn()),
          const VerticalDivider(width: 1),
          // Columna 3: Ofertas Sugeridas (25%) - ¡Consume el ViewModel!
          const Expanded(flex: 25, child: SuggestedOffersColumn()),
        ],
      ),
    );
  }
}

// --------------------------------
// Columnas (Widgets de Contenido)
// -------------------------------

class CurriculumColumn extends StatelessWidget {
  const CurriculumColumn({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text('Columna 1: Perfil y Curriculum (Pendiente de ViewModel)'),
      ),
    );
  }
}

class AppliedOffersColumn extends StatelessWidget {
  const AppliedOffersColumn({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text('Columna 2: Mis Postulaciones (Pendiente de ViewModel)'),
      ),
    );
  }
}

// Columna 3: Consume el userHomeViewModelProvider
class SuggestedOffersColumn extends ConsumerWidget {
  const SuggestedOffersColumn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userHomeViewModelProvider);
    final userNotifier = ref.read(userHomeViewModelProvider.notifier);

    return Container(
      color: Colors.grey[50], // Fondo claro para diferenciar
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Ofertas Sugeridas', style: TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.refresh, size: 20),
                onPressed: userNotifier.loadRecommendedOffers,
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: switch (userState.status) {
              HomeStatus.loading || HomeStatus.initial => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              HomeStatus.error => Center(
                child: Text('Error: ${userState.errorMessage}', textAlign: TextAlign.center),
              ),
              HomeStatus.loaded => ListView.builder(
                itemCount: userState.data.length,
                itemBuilder: (context, index) {
                  final offer = userState.data[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(offer.title, style: const TextStyle(fontSize: 14)),
                      subtitle: Text('${offer.company} - ${offer.location}'),
                      dense: true,
                      onTap: () {
                        // Navegar al detalle de la oferta
                      },
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

// ... (Se omitió el _MobileView por simplicidad, pero sigue la misma lógica)
class _MobileView extends StatelessWidget {
  final AuthNotifier authNotifier;
  const _MobileView({required this.authNotifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil'), actions: [
        IconButton(icon: const Icon(Icons.logout), onPressed: authNotifier.logout)
      ]),
      body: const Center(child: Text("Vista Móvil")),
    );
  }
}