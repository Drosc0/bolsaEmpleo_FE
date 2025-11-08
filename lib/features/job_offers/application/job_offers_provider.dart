import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bolsa_empleo/features/job_offers/domain/job_offer.dart'; // Asegúrate que esta ruta es correcta

// -------------------------------------------------------------------
// 1. REPOSITORIO SIMULADO (FAKE) ACTUALIZADO
// -------------------------------------------------------------------

class FakeJobOffersRepository {
  Future<List<JobOffer>> fetchOffers() async {
    // Simula una llamada a la API de NestJS
    await Future.delayed(const Duration(seconds: 1)); 

    return [
      JobOffer(
        id: '1', title: 'Senior Flutter Developer', company: 'Global Tech', 
        location: 'Remoto', minSalary: 60000, maxSalary: 80000, 
        description: 'Buscamos un desarrollador experimentado con más de 5 años de experiencia...',
        contractType: 'Indefinido', // ⬅️ CAMPO REQUERIDO
        postedDate: DateTime.now().subtract(const Duration(days: 5)), // ⬅️ CAMPO REQUERIDO
      ),
      JobOffer(
        id: '2', title: 'Product Manager', company: 'Innovate SA', 
        location: 'Madrid, Híbrido', minSalary: 50000, maxSalary: 70000, 
        description: 'Liderarás la estrategia de producto y la comunicación entre equipos.',
        contractType: 'Temporal',
        postedDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      JobOffer(
        id: '3', title: 'Junior UX/UI Designer', company: 'Creative Hub', 
        location: 'Barcelona', minSalary: 25000, maxSalary: 35000, 
        description: 'Únete a nuestro equipo de diseño y aprende de los mejores.',
        contractType: 'Prácticas',
        postedDate: DateTime.now().subtract(const Duration(days: 10)),
      ),
      JobOffer(
        id: '4', title: 'Data Scientist (Python)', company: 'Data Minds', 
        location: 'Remoto', minSalary: 75000, maxSalary: 95000, 
        description: 'Expertos en modelos de machine learning y procesamiento de datos masivos.',
        contractType: 'Indefinido',
        postedDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      JobOffer(
        id: '5', title: 'NestJS Backend Engineer', company: 'Digital Solutions', 
        location: 'Remoto', minSalary: 55000, maxSalary: 70000, 
        description: 'Desarrollo de microservicios robustos y escalables con NestJS y TypeScript.',
        contractType: 'Freelance',
        postedDate: DateTime.now().subtract(const Duration(days: 7)),
      ),
      JobOffer(
        id: '6', title: 'Frontend Developer (Angular)', company: 'WebCrafters', 
        location: 'Valencia', minSalary: 35000, maxSalary: 50000, 
        description: 'Buscamos desarrolladores Angular 14+ con enfoque en rendimiento y accesibilidad.',
        contractType: 'Indefinido',
        postedDate: DateTime.now().subtract(const Duration(hours: 12)),
      ),
    ];
  }
}

// -------------------------------------------------------------------
// 2. PROVEEDORES
// -------------------------------------------------------------------

// Proveedor del repositorio (para fácil inyección en pruebas y VM)
final jobOfferRepositoryProvider = Provider((ref) => FakeJobOffersRepository());

/// StateNotifier (ViewModel) que gestiona el estado de las ofertas de trabajo.
/// Usaremos AsyncNotifier si estás en Riverpod 2.0+ para una gestión más limpia de AsyncValue.
class JobOffersNotifier extends AsyncNotifier<List<JobOffer>> {
  
  // Método obligatorio para inicializar el estado
  @override
  Future<List<JobOffer>> build() async {
    final repository = ref.watch(jobOfferRepositoryProvider);
    return repository.fetchOffers();
  }

  /// Método para recargar las ofertas (útil para pull-to-refresh)
  Future<void> refreshOffers() async {
    state = const AsyncValue.loading();
    await build();
  }
}

// El proveedor principal que se consume en la UI
final jobOffersProvider = AsyncNotifierProvider<JobOffersNotifier, List<JobOffer>>(() {
  return JobOffersNotifier();
});