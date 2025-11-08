import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Importamos el ViewModel y el Estado
import '../../../../application/applicant/profile/user_profile_view_model.dart'; 

// -------------------------------------------------------------------
// 1. PROVIDERS PARA LOS CONTROLADORES (Manejo de Dispose)
// -------------------------------------------------------------------

// Proporciona el controlador de nombre y lo desecha automáticamente
final nameControllerProvider = Provider.autoDispose((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

final phoneControllerProvider = Provider.autoDispose((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

final summaryControllerProvider = Provider.autoDispose((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

// -------------------------------------------------------------------
// 2. WIDGET PRINCIPAL
// -------------------------------------------------------------------

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observar el estado y los notifiers
    final profileState = ref.watch(userProfileViewModelProvider);
    final profileNotifier = ref.read(userProfileViewModelProvider.notifier);
    
    // Obtener los controladores desde los providers
    final nameController = ref.watch(nameControllerProvider);
    final phoneController = ref.watch(phoneControllerProvider);
    final summaryController = ref.watch(summaryControllerProvider);

    // Escuchar cambios de estado para inicialización, guardado y errores
    ref.listen<UserProfileState>(userProfileViewModelProvider, (previous, next) {
      final snackBar = ScaffoldMessenger.of(context);
      
      // Inicializar valores al cargar por primera vez
      if (next.status == ProfileStatus.loaded && previous?.status != ProfileStatus.loaded) {
        if (next.profile != null) {
          nameController.text = next.profile!.name;
          phoneController.text = next.profile!.phone;
          summaryController.text = next.profile!.summary;
        }
      }

      // Manejar el éxito al guardar
      if (previous?.status == ProfileStatus.saving && next.status == ProfileStatus.loaded && next.errorMessage == null) {
        snackBar.showSnackBar(
          const SnackBar(
            content: Text('✅ Perfil actualizado con éxito!'), 
            backgroundColor: Colors.green
          )
        );
      }
      
      // Manejar errores
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        snackBar.showSnackBar(
          SnackBar(
            content: Text('❌ Error: ${next.errorMessage!}'), 
            backgroundColor: Colors.red
          )
        );
      }
    });

    final isLoading = profileState.status == ProfileStatus.loading;
    final isSaving = profileState.status == ProfileStatus.saving;
    final isBusy = isLoading || isSaving;

    // Manejo del contenido de la pantalla basado en el estado
    Widget bodyContent;
    
    if (isLoading) {
      bodyContent = const Center(child: CircularProgressIndicator());
    } else if (profileState.profile == null && profileState.status == ProfileStatus.error) {
      bodyContent = Center(child: Text('Error al cargar: ${profileState.errorMessage}'));
    } else if (profileState.profile == null) {
      bodyContent = const Center(child: Text('Cargando perfil...'));
    } else {
      bodyContent = SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sección de Datos Básicos
            const Text('Datos Básicos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre Completo'),
              enabled: !isBusy,
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              initialValue: profileState.profile!.email,
              decoration: const InputDecoration(labelText: 'Email (No editable)'),
              readOnly: true,
            ),
            
            const SizedBox(height: 16),

            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Teléfono'),
              keyboardType: TextInputType.phone,
              enabled: !isBusy,
            ),
            
            const SizedBox(height: 16),

            TextFormField(
              controller: summaryController,
              decoration: const InputDecoration(labelText: 'Resumen Profesional / Acerca de mí'),
              maxLines: 4,
              enabled: !isBusy,
            ),
            
            const SizedBox(height: 32),

            // Botón de Guardar
            ElevatedButton(
              onPressed: isBusy
                  ? null
                  : () {
                      profileNotifier.updateBasicProfile(
                        name: nameController.text,
                        phone: phoneController.text,
                        summary: summaryController.text,
                      );
                    },
              child: isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Guardar Cambios'),
            ),
            
            const SizedBox(height: 40),
            
            // Sección de Experiencia
            _ExperienceSection(
              experiences: profileState.profile!.experience,
              profileNotifier: profileNotifier, // Pasamos el notifier
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil y CV'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: bodyContent,
    );
  }
}

// -------------------------------------------------------------------
// 3. WIDGET DE LA SECCIÓN DE EXPERIENCIA (Actualizado)
// -------------------------------------------------------------------

class _ExperienceSection extends StatelessWidget {
  final List<Experience> experiences;
  final UserProfileViewModel profileNotifier;

  const _ExperienceSection({required this.experiences, required this.profileNotifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Experiencia Laboral',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                // TO-DO: Implementar navegación para añadir nueva experiencia (usaremos un modal)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('TO-DO: Abrir modal para Añadir Experiencia'))
                );
              },
            ),
          ],
        ),
        const Divider(),
        if (experiences.isEmpty) 
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text('Aún no has agregado experiencia laboral.', style: TextStyle(fontStyle: FontStyle.italic)),
          ),
        ...experiences.map((exp) => ListTile(
          title: Text(exp.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${exp.company} (${exp.startDate.year} - ${exp.endDate?.year ?? 'Actualidad'})'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () {
                  // TO-DO: Implementar navegación para editar experiencia
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                onPressed: () async {
                  // Lógica de eliminación (ejemplo)
                  await profileNotifier.deleteExperience(exp.id);
                },
              ),
            ],
          ),
          onTap: () {
            // Mostrar detalles o editar
          },
        )),
      ],
    );
  }
}