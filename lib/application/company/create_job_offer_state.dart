enum CreateOfferStatus { initial, validating, submitting, success, failure }

class CreateJobOfferState {
  final CreateOfferStatus status;
  final String? errorMessage;
  
  // Datos del formulario
  final String title;
  final String description;
  final String location;
  final String contractType;
  final int? minSalary;
  final int? maxSalary;

  const CreateJobOfferState({
    this.status = CreateOfferStatus.initial,
    this.errorMessage,
    this.title = '',
    this.description = '',
    this.location = '',
    this.contractType = 'Indefinido', // Valor predeterminado
    this.minSalary,
    this.maxSalary,
  });

  // Método manual para inmutabilidad y copia
  CreateJobOfferState copyWith({
    CreateOfferStatus? status,
    String? errorMessage,
    String? title,
    String? description,
    String? location,
    String? contractType,
    int? minSalary,
    int? maxSalary,
  }) {
    return CreateJobOfferState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      contractType: contractType ?? this.contractType,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
    );
  }
}