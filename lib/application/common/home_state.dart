enum HomeStatus { 
  initial, 
  loading, 
  loaded, 
  error 
}

// home_state.dart

class HomeState<T> {
  final HomeStatus status;
  final T? data;
  final String? errorMessage;

  HomeState({
    this.status = HomeStatus.initial,
    this.data,
    this.errorMessage,
  });

  // Método para crear una nueva instancia con valores actualizados
  HomeState<T> copyWith({
    HomeStatus? status,
    T? data,
    String? errorMessage,
  }) {
    return HomeState<T>(
      status: status ?? this.status,
      // Usar 'data' de forma segura, permitiendo que sea nulo si se pasa
      data: data, 
      errorMessage: errorMessage, 
    );
  }
}