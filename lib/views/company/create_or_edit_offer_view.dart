import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viemodels/company_offer_form_view_model.dart';
import '../../models/job_offer.dart';

class CreateOrEditOfferView extends StatelessWidget {
  final JobOffer? offer; // Null si es creación
  
  const CreateOrEditOfferView({this.offer, super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Inyectar el ViewModel con la oferta inicial si existe
    return ChangeNotifierProvider(
      create: (_) => CompanyOfferFormViewModel(offer: offer),
      child: Consumer<CompanyOfferFormViewModel>(
        builder: (context, vm, child) {
          final title = vm.isEditing ? 'Editar Oferta: ${offer!.title}' : 'Publicar Nueva Oferta';
          
          return Scaffold(
            appBar: AppBar(title: Text(title)),
            body: const _OfferFormBody(),
          );
        },
      ),
    );
  }
}

class _OfferFormBody extends StatefulWidget {
  const _OfferFormBody();

  @override
  State<_OfferFormBody> createState() => _OfferFormBodyState();
}

class _OfferFormBodyState extends State<_OfferFormBody> {
  final _formKey = GlobalKey<FormState>();

  void _submitForm() async {
    final vm = Provider.of<CompanyOfferFormViewModel>(context, listen: false);
    
    if (_formKey.currentState!.validate()) {
      bool success = await vm.saveOffer();
      
      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Oferta ${vm.isEditing ? 'actualizada' : 'creada'} con éxito!'), backgroundColor: Colors.green),
          );
          Navigator.of(context).pop(); // Volver a CompanyHomeView
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(vm.errorMessage ?? 'Error desconocido.'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CompanyOfferFormViewModel>(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 1. Campo Título
            _buildTextField(vm.titleController, 'Título del Puesto', Icons.work),
            // 2. Campo Ubicación
            _buildTextField(vm.locationController, 'Ubicación (Ej: Remoto, Madrid)', Icons.location_on),
            // 3. Campo Salario
            _buildTextField(vm.salaryController, 'Salario (anual en €)', Icons.attach_money, isNumeric: true, isOptional: true),
            // 4. Campo Descripción
            _buildTextArea(vm.descriptionController, 'Descripción Completa del Puesto', Icons.description),
            // 5. Campo Requisitos
            _buildTextArea(vm.requirementsController, 'Requisitos (Uno por línea)', Icons.list_alt, isOptional: true),

            const SizedBox(height: 30),
            
            vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
                    onPressed: _submitForm,
                    icon: Icon(vm.isEditing ? Icons.save : Icons.add_circle),
                    label: Text(vm.isEditing ? 'Guardar Cambios' : 'Publicar Oferta'),
                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                  ),
          ],
        ),
      ),
    );
  }
  
  // --- Widgets Auxiliares ---
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isNumeric = false,
    bool isOptional = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (!isOptional && (value == null || value.isEmpty)) {
            return 'Por favor, ingresa el $label.';
          }
          if (isNumeric && value != null && value.isNotEmpty && double.tryParse(value) == null) {
            return 'Debe ser un número válido.';
          }
          return null;
        },
      ),
    );
  }
  
  Widget _buildTextArea(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isOptional = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        maxLines: 5,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          alignLabelWithHint: true,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (!isOptional && (value == null || value.isEmpty)) {
            return 'Por favor, ingresa la $label.';
          }
          return null;
        },
      ),
    );
  }
}