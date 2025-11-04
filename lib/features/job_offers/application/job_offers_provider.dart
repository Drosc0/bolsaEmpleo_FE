import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/job_offer.dart';

// Definición del estado
typedef JobOffersState = AsyncValue<List<JobOffer>>;

// Simulamos la fuente de datos (Repositorio/Service que usará Dio)
class FakeJobOffersRepository {
  Future<List<JobOffer>> fetchOffers() async {
    // Simula una llamada a la API de NestJS
    await Future.delayed(const Duration(seconds: 1)); 

    return [
      JobOffer(
        id: '1', title: 'Senior Flutter Developer', company: 'Global Tech', 
        location: 'Remoto', minSalary: 60, maxSalary: 80, 
        description: 'Buscamos un desarrollador experimentado...',
      ),
      JobOffer(
        id: '2', title: 'Product Manager', company: 'Innovate SA', 
        location: 'Madrid, Híbrido', minSalary: 50, maxSalary: 70, 
        description: 'Liderarás la estrategia de producto...',
      ),
      JobOffer(
        id: '3', title: 'Junior UX/UI Designer', company: 'Creative Hub', 
        location: 'Barcelona', minSalary: 25, maxSalary: 35, 
        description: 'Únete a nuestro equipo de diseño...',
      ),
      JobOffer(
        id: '4', title: 'Data Scientist (Python)', company: 'Data Minds', 
        location: 'Remoto', minSalary: 75, maxSalary: 95, 
        description: 'Expertos en modelos de machine learning...',
      ),
      JobOffer(
        id: '5', title: 'NestJS Backend Engineer', company: 'Digital Solutions', 
        location: 'Remoto', minSalary: 55, maxSalary: 70, 
        description: 'Desarrollo de microservicios con NestJS...',
      ),
      JobOffer(
        id: '6', title: 'Frontend Developer (Angular)', company: 'WebCrafters', 
        location: 'Valencia', minSalary: 35, maxSalary: 50, 
        description: 'Buscamos desarrolladores Angular 14+...',
      ),
    ];
  }
}

// StateNotifier que carga las ofertas al inicializarse
class JobOffersNotifier extends StateNotifier<JobOffersState> {
  final FakeJobOffersRepository repository;

  JobOffersNotifier(this.repository) : super(const JobOffersState.loading()) {
    fetchOffers();
  }

  Future<void> fetchOffers() async {
    state = const JobOffersState.loading();
    try {
      final offers = await repository.fetchOffers();
      state = JobOffersState.data(offers);
    } catch (e, stack) {
      state = JobOffersState.error(e, stack);
    }
  }
}

// Proveedor de Riverpod
final jobOffersProvider = StateNotifierProvider<JobOffersNotifier, JobOffersState>((ref) {
  // Aquí es donde inyectarías tu ApiService real
  final repository = FakeJobOffersRepository(); 
  return JobOffersNotifier(repository);
});