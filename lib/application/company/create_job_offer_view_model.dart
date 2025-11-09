import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/job_offers_repository.dart'; 
import 'create_job_offer_state.dart';
import '../../domain/repositories/job_offers_repository.dart' show JobOffersRepository, jobOffersRepositoryProvider;


class CreateJobOfferViewModel extends StateNotifier<CreateJobOfferState> {
  final JobOffersRepository _repository;

  CreateJobOfferViewModel(this._repository) : super(const CreateJobOfferState());

  // --- Métodos de Actualización de Campos ---
  void updateTitle(String value) => state = state.copyWith(title: value);
  void updateDescription(String value) => state = state.copyWith(description: value);
  void updateLocation(String value) => state = state.copyWith(location: value);
  void updateContractType(String value) => state = state.copyWith(contractType: value);
  // Manejamos null para permitir borrar el campo de salario
  void updateMinSalary(String value) => state = state.copyWith(minSalary: int.tryParse(value));
  void updateMaxSalary(String value) => state = state.copyWith(maxSalary: int.tryParse(value));
  
  void resetState() => state = const CreateJobOfferState();
  
  // --- Lógica de Publicación ---
  Future<void> submitOffer() async {
    state = state.copyWith(status: CreateOfferStatus.validating, errorMessage: null);

    // 1. Validación Básica
    if (state.title.isEmpty || state.description.isEmpty || state.minSalary == null) {
      state = state.copyWith(
        status: CreateOfferStatus.failure,
        errorMessage: 'Por favor, completa el título, la descripción y el salario mínimo.',
      );
      return;
    }
    
    // Validación de Salario
    if (state.maxSalary != null && state.minSalary! > state.maxSalary!) {
       state = state.copyWith(
        status: CreateOfferStatus.failure,
        errorMessage: 'El salario mínimo no puede ser mayor que el salario máximo.',
      );
      return;
    }

    state = state.copyWith(status: CreateOfferStatus.submitting);

    try {
      // falta: Obtener el ID de la empresa real autenticada
      const companyId = 'company-id-123';
      
      // 2. Llamada al Repositorio
      await _repository.createJobOffer(
        companyId: companyId,
        title: state.title,
        description: state.description,
        location: state.location,
        contractType: state.contractType,
        minSalary: state.minSalary!,
        maxSalary: state.maxSalary ?? state.minSalary!, // Si no hay máx, usamos el mín
      );

      state = state.copyWith(status: CreateOfferStatus.success);

    } catch (e) {
      state = state.copyWith(
        status: CreateOfferStatus.failure,
        errorMessage: 'Fallo al publicar la oferta: ${e.toString()}',
      );
    }
  }
}

final createJobOfferViewModelProvider = 
    StateNotifierProvider.autoDispose<CreateJobOfferViewModel, CreateJobOfferState>((ref) {
  final repository = ref.watch(jobOffersRepositoryProvider); 
  return CreateJobOfferViewModel(repository);
});