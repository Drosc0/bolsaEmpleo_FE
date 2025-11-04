import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viemodels/profile_viewmodel.dart';
import '../../../models/aspirant_profile.dart'; // Para el modelo de datos

class ProfileManagementView extends StatefulWidget {
  const ProfileManagementView({super.key});

  @override
  State<ProfileManagementView> createState() => _ProfileManagementViewState();
}

class _ProfileManagementViewState extends State<ProfileManagementView> {
  @override
  void initState() {
    super.initState();
    // Inicia la carga del perfil cuando la vista se crea
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileViewModel>(context, listen: false).fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestionar Currículum')),
      body: Consumer<ProfileViewModel>(
        builder: (context, profileVM, child) {
          if (profileVM.isLoadingProfile) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (profileVM.profile == null) {
            return const Center(child: Text('Error al cargar o perfil no creado.'));
          }

          final profile = profileVM.profile!;
          
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildProfileSummary(profile),
              const Divider(),
              _buildSectionTitle(context, 'Experiencia Laboral', () => {}), // Función para añadir
              _buildExperienceList(profile.experience),
              const Divider(),
              _buildSectionTitle(context, 'Habilidades', () => {}), // Función para añadir
              _buildSkillsGrid(profile.skills),
            ],
          );
        },
      ),
    );
  }
  
  // --- Widgets Auxiliares ---
  
  Widget _buildProfileSummary(AspirantProfile profile) {
    return Card(
      child: ListTile(
        title: Text(profile.name),
        subtitle: Text(profile.summary ?? 'Sin resumen.'),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            // Navegar a ProfileEditView
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, VoidCallback onAdd) {
    return ListTile(
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      trailing: IconButton(
        icon: const Icon(Icons.add),
        onPressed: onAdd,
      ),
    );
  }
  
  Widget _buildExperienceList(List experience) {
    // Implementación del ListView o Column de experiencias
    return const SizedBox.shrink();
  }

  Widget _buildSkillsGrid(List skills) {
    // Implementación de GridView de habilidades
    return const SizedBox.shrink();
  }
}