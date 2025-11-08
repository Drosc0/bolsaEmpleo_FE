import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../application/auth/auth_provider.dart'; 
import '../../../shared/presentation/widgets/responsive_layout.dart'; 

class UserHomeScreen extends ConsumerWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authProvider.notifier);

    // Si la pantalla es pequeña, mostramos una columna simple, si es grande, 3 columnas.
    return ResponsiveLayout(
      mobile: _MobileView(authNotifier: authNotifier),
      web: _WebView(authNotifier: authNotifier),
    );
  }
}

// Sub-Widget para la vista WEB (3 Columnas)

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
          // Columna 1: Info del Curriculum (25% del ancho)
          const Expanded(
            flex: 25,
            child: CurriculumColumn(),
          ),
          const VerticalDivider(),
          // Columna 2: Ofertas a las que se ha postulado (50% del ancho)
          const Expanded(
            flex: 50,
            child: AppliedOffersColumn(),
          ),
          const VerticalDivider(),
          // Columna 3: Ofertas Sugeridas (25% del ancho)
          const Expanded(
            flex: 25,
            child: SuggestedOffersColumn(),
          ),
        ],
      ),
    );
  }
}

// Sub-Widget para la vista MÓVIL (Pestañas o Scroll)

class _MobileView extends StatelessWidget {
  final AuthNotifier authNotifier;

  const _MobileView({required this.authNotifier});

  @override
  Widget build(BuildContext context) {
    // Usamos DefaultTabController para simular las 3 columnas en pestañas
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mi Perfil'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: authNotifier.logout,
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person), text: 'CV'),
              Tab(icon: Icon(Icons.check_circle_outline), text: 'Postuladas'),
              Tab(icon: Icon(Icons.lightbulb_outline), text: 'Sugeridas'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CurriculumColumn(),
            AppliedOffersColumn(),
            SuggestedOffersColumn(),
          ],
        ),
      ),
    );
  }
}

// Componentes Reutilizables (Las 3 Columnas)

class CurriculumColumn extends StatelessWidget {
  const CurriculumColumn({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Columna 1: Información del Currículum'));
  }
}

class AppliedOffersColumn extends StatelessWidget {
  const AppliedOffersColumn({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Columna 2: Ofertas a las que me he postulado'));
  }
}

class SuggestedOffersColumn extends StatelessWidget {
  const SuggestedOffersColumn({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Columna 3: Ofertas Sugeridas'));
  }
}