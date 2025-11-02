import 'package:flutter/material.dart';
import '../models/job_offer.dart';
import '../services/offer_service.dart';

class CompanyOfferFormViewModel extends ChangeNotifier {
  final OfferService _offerService = OfferService();
  
  // Estado
  bool _isLoading = false;
  String? _errorMessage;
  JobOffer? _initialOffer; // Oferta si estamos editando
  
  // Datos del Formulario (controlados por la Vista)
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController requirementsController = TextEditingController(); 

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEditing => _initialOffer != null;

  CompanyOfferFormViewModel({JobOffer? offer}) : _initialOffer = offer {
    if (offer != null) {
      // Precargar datos si estamos editando
      titleController.text = offer.title;
      descriptionController.text = offer.description;
      locationController.text = offer.location;
      // Convertir número a string para el TextField
      salaryController.text = offer.salary?.toStringAsFixed(0) ?? '';
      // Unir la lista de requisitos en un solo texto (ej: separados por línea)
      requirementsController.text = offer.requirements?.join('\n') ?? ''; 
    }
  }
  
  // --- Lógica de Creación/Edición ---

  Future<bool> saveOffer() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    // 1. Recolectar datos del formulario
    final salaryValue = double.tryParse(salaryController.text);
    final requirementsList = requirementsController.text.split('\n').where((s) => s.trim().isNotEmpty).toList();
    
    final Map<String, dynamic> offerData = {
      'title': titleController.text,
      'description': descriptionController.text,
      'location': locationController.text,
      'salary': salaryValue,
      'requirements': requirementsList,
    };
    
    try {
      // 2. Llamar al servicio basado en si es creación o edición
      if (isEditing) {
        await _offerService.updateOffer(_initialOffer!.id, offerData);
      } else {
        await _offerService.createOffer(offerData);
      }
      return true; // Éxito
    } catch (e) {
      _errorMessage = 'Error al ${isEditing ? 'actualizar' : 'crear'} la oferta: ${e.toString()}';
      return false; // Fallo
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // No olvidar limpiar los controladores
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    salaryController.dispose();
    requirementsController.dispose();
    super.dispose();
  }
}