import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viemodels/auth_view_model.dart';
import '../../viemodels/company_offers_view_model.dart';
import '../../models/job_offer.dart';
import '../auth/login_view.dart';
import 'create_or_edit_offer_view.dart'; 
import 'offer_applications_view.dart'; 


class CompanyHomeView extends StatefulWidget {
  const CompanyHomeView({super.key});

  @override
  State<CompanyHomeView> createState() => _CompanyHomeViewState();
}

class _CompanyHomeViewState extends State<CompanyHomeView> {
  
  @override
  void initState() {
    super.initState();
    // Cargar las ofertas de la empresa al iniciar la vista
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CompanyOffersViewModel>(context, listen: false).loadMyOffers();
    });
  }

  void _logout(BuildContext context) async {
    await Provider.of<AuthViewModel>(context, listen: false).logout();
    if (context.mounted) {
       // Navega al Login y elimina todas las rutas anteriores
       Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginView()),
          (Route<dynamic> route) => false,
      );
    }
  }

  // --- Lógica de Navegación ---
  void _navigateToCreateOffer(BuildContext context, [JobOffer? offerToEdit]) {
    // ⚠️ TODO: Navegación a la vista de creación/edición
    // final vm = Provider.of<CompanyOffersViewModel>(context, listen: false);
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (_) => CreateOrEditOfferView(offer: offerToEdit)),
    // ).then((_) => vm.refreshOffers()); // Refresca la lista al volver
    
    String action = offerToEdit == null ? 'Crear' : 'Editar';
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$action Oferta (Vista pendiente de implementación).')),
      );
  }

  void _navigateToApplications(BuildContext context, JobOffer offer) {
     // ⚠️ TODO: Navegación a la vista de postulantes para una oferta
     // Navigator.of(context).push(
     //   MaterialPageRoute(builder: (_) => OfferApplicationsView(offerId: offer.id, offerTitle: offer.title)),
     // );
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ver postulantes para ${offer.title} (Vista pendiente de implementación).')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Empresa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      
      // --- Drawer ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(authVM.currentUser?.companyName ?? 'Mi Empresa'),
              accountEmail: Text('Email: ${authVM.currentUser?.email ?? ''}'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.business, size: 40),
              ),
            ),
            ListTile(
              title: const Text('Publicar Nueva Oferta'),
              leading: const Icon(Icons.add_box),
              onTap: () {
                Navigator.of(context).pop(); 
                _navigateToCreateOffer(context);
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Cerrar Sesión'),
              leading: const Icon(Icons.logout, color: Colors.red),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      
      // --- Contenido Principal: Lista de Ofertas Propias ---
      body: Consumer<CompanyOffersViewModel>(
        builder: (context, offersVM, child) {
          if (offersVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
  
          if (offersVM.errorMessage != null) {
            return Center(child: Text(offersVM.errorMessage!));
          }
  
          if (offersVM.myOffers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Aún no has publicado ninguna oferta.', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 15),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Publicar Oferta'),
                    onPressed: () => _navigateToCreateOffer(context),
                  ),
                ],
              ),
            );
          }
  
          return RefreshIndicator(
            onRefresh: offersVM.refreshOffers, // Permite recargar deslizando
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: offersVM.myOffers.length,
              itemBuilder: (context, index) {
                final offer = offersVM.myOffers[index];
                return CompanyOfferCard(
                  offer: offer, 
                  onViewApplications: () => _navigateToApplications(context, offer),
                  onEdit: () => _navigateToCreateOffer(context, offer),
                ); 
              },
            ),
          );
        },
      ),
      
      // Botón flotante para la acción principal
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateOffer(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// --- Widget Auxiliar para la Tarjeta de Oferta de la Empresa ---
class CompanyOfferCard extends StatelessWidget {
  final JobOffer offer;
  final VoidCallback onViewApplications;
  final VoidCallback onEdit;
  // ⚠️ Podrías añadir un VoidCallback onDelete;

  const CompanyOfferCard({
    required this.offer,
    required this.onViewApplications,
    required this.onEdit,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    // ⚠️ Se asume que el backend devuelve un conteo de postulantes en la oferta (offer.applicationsCount)
    // Si no lo hace, este dato se obtendría en el OfferApplicationsView.
    final int applicantCount = offer.applicationsCount ?? 0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      child: ExpansionTile(
        leading: const Icon(Icons.work_outline, color: Colors.indigo),
        title: Text(offer.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Localización: ${offer.location} | Postulantes: $applicantCount'),
        trailing: const Icon(Icons.keyboard_arrow_down),
        children: <Widget>[
          const Divider(height: 1, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Salario: \$${offer.salary.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w500)),
                Text('Publicada: ${offer.postedAt.toLocal().toString().split(' ')[0]}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                Text(
                  offer.description.length > 150 
                  ? offer.description.substring(0, 150) + '...' 
                  : offer.description,
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                icon: const Icon(Icons.people_alt, color: Colors.blue),
                label: Text('VER POSTULANTES ($applicantCount)'),
                onPressed: onViewApplications,
              ),
              TextButton.icon(
                icon: const Icon(Icons.edit, color: Colors.orange),
                label: const Text('EDITAR'),
                onPressed: onEdit,
              ),
              // TextButton.icon( ... ELIMINAR ... )
            ],
          ),
        ],
      ),
    );
  }
}