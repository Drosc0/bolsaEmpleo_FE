import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Asumo que estos ViewModels existen o los crearemos después
// import '../../../../application/company/company_dashboard_view_model.dart'; 
//import 'create_job_offer_screen.dart'; // Para la navegación

class CompanyDashboardScreen extends ConsumerWidget {
  const CompanyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // falta: Aquí se observaría el CompanyDashboardViewModel para obtener métricas
    // final dashboardState = ref.watch(companyDashboardViewModelProvider);
    
    // Usaremos datos dummy mientras creamos el ViewModel
    const activeOffers = 5;
    const totalApplicants = 45;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Control de la Empresa'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saludo
            Text(
              '¡Bienvenido/a de vuelta!',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 20),

            // Tarjetas de Métricas Clave
            _buildMetricsGrid(context, activeOffers, totalApplicants),
            const SizedBox(height: 30),

            // Acciones Rápidas
            Text(
              'Acciones Rápidas',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            
            _buildQuickActionCard(
              context,
              icon: Icons.add_circle_outline,
              title: 'Publicar Nueva Oferta',
              subtitle: 'Crea y publica un nuevo puesto de trabajo.',
              onTap: () {
                // falta: Implementar navegación al formulario de creación
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreateJobOfferScreen()));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navegando a Publicar Oferta...'))
                );
              },
            ),
            
            _buildQuickActionCard(
              context,
              icon: Icons.people_alt_outlined,
              title: 'Revisar Postulantes',
              subtitle: 'Visualiza y gestiona las postulaciones a tus ofertas.',
              onTap: () {
                // falta: Implementar navegación a la lista de postulantes
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navegando a Revisar Postulantes...'))
                );
              },
            ),

            const SizedBox(height: 30),
            
            //  Lista de Ofertas Recientes (Placeholder)
            Text(
              'Ofertas Activas Recientes',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // falta: Aquí iría un ListView.builder observando el ViewModel para mostrar las ofertas
            const Placeholder(fallbackHeight: 150), 
          ],
        ),
      ),
    );
  }

  /// -----------------------------------------------------------
  /// WIDGETS AUXILIARES
  /// -----------------------------------------------------------

  Widget _buildMetricsGrid(BuildContext context, int activeOffers, int totalApplicants) {
    return Row(
      children: [
        // Tarjeta de Ofertas Activas
        Expanded(
          child: _MetricCard(
            icon: Icons.work_outline,
            title: 'Ofertas Activas',
            value: activeOffers.toString(),
            color: Colors.teal,
          ),
        ),
        const SizedBox(width: 16),
        // Tarjeta de Postulantes Totales
        Expanded(
          child: _MetricCard(
            icon: Icons.person_add_alt_1_outlined,
            title: 'Postulantes Totales',
            value: totalApplicants.toString(),
            color: Colors.deepPurple,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Theme.of(context).colorScheme.tertiary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

// -----------------------------------------------------------
// WIDGET CARD para Métricas
// -----------------------------------------------------------

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _MetricCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 10),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}