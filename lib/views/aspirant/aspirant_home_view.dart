import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viemodels/auth_view_model.dart';
import '../../viemodels/offers_view_model.dart';
import '../../models/job_offer.dart';
import '../auth/login_view.dart';
import 'profile/profile_management_view.dart';

class AspirantHomeView extends StatefulWidget {
  const AspirantHomeView({super.key});

  @override
  State<AspirantHomeView> createState() => _AspirantHomeViewState();
}

class _AspirantHomeViewState extends State<AspirantHomeView> {
  // Controlador para el scroll infinito
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    // Inicia la carga de la primera página de ofertas
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OffersViewModel>(context, listen: false).loadInitialOffers();
    });
    
    // Añade listener para manejar el scroll infinito (cargar más ofertas)
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offersVM = Provider.of<OffersViewModel>(context, listen: false);
    // Detecta si el usuario está cerca del final de la lista
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      offersVM.loadNextPage();
    }
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
  
  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).pop(); // Cierra el Drawer
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProfileManagementView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Escucha al AuthViewModel para obtener la información básica del usuario para el Drawer
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Búsqueda de Empleo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      
      // --- Drawer (Menú Lateral) ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(authVM.currentUser?.email ?? 'Aspirante'),
              accountEmail: Text('Rol: ${authVM.currentUser?.role.name.toUpperCase()}'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40),
              ),
            ),
            ListTile(
              title: const Text('Gestionar CV'),
              leading: const Icon(Icons.assignment),
              onTap: () => _navigateToProfile(context),
            ),
            ListTile(
              title: const Text('Mis Postulaciones'),
              leading: const Icon(Icons.work),
              onTap: () {
                 // Navegar a MyApplicationsView
                 Navigator.of(context).pop(); 
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
      
      // --- Contenido Principal: Lista de Ofertas ---
      body: Column(
        children: [
          // Área para la barra de búsqueda y filtros
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar por título o ubicación...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              // Implementar onChange para llamar a offersVM.applyFilters
            ),
          ),
          
          Expanded(
            child: Consumer<OffersViewModel>(
              builder: (context, offersVM, child) {
                if (offersVM.isLoading && offersVM.offers.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
        
                if (offersVM.errorMessage != null) {
                  return Center(
                    child: Text(offersVM.errorMessage!),
                  );
                }
        
                if (offersVM.offers.isEmpty) {
                  return const Center(child: Text('No se encontraron ofertas.'));
                }
        
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: offersVM.offers.length + (offersVM.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Muestra el indicador de carga en la parte inferior si hay más datos
                    if (index == offersVM.offers.length && offersVM.hasMore) {
                      return const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
        
                    final offer = offersVM.offers[index];
                    return JobOfferCard(offer: offer); 
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- Widget Auxiliar para la Tarjeta de Oferta ---
class JobOfferCard extends StatelessWidget {
  final JobOffer offer;

  const JobOfferCard({required this.offer, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.work_outline, color: Colors.blue),
        title: Text(offer.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(offer.companyName),
            Text('${offer.location} - \$${offer.salary.toStringAsFixed(0)}'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // ⚠️ Implementar: Navegar a OfferDetailsView(offerId: offer.id)
        },
      ),
    );
  }
}