import 'package:bolsa_empleo/application/company/create_job_offer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../application/company/create_job_offer_view_model.dart';

// Lista de tipos de contrato de ejemplo
const List<String> contractTypes = ['Indefinido', 'Temporal', 'Freelance', 'Prácticas'];

class CreateJobOfferScreen extends ConsumerWidget {
  const CreateJobOfferScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createJobOfferViewModelProvider);
    final notifier = ref.read(createJobOfferViewModelProvider.notifier);
    final formKey = GlobalKey<FormState>();

    // Escuchar el resultado del envío
    ref.listen<CreateJobOfferState>(createJobOfferViewModelProvider, (previous, next) {
      if (next.status == CreateOfferStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Oferta publicada con éxito! 🎉'), backgroundColor: Colors.green),
        );
        // Regresar al dashboard después del éxito
        Navigator.of(context).pop();
      } else if (next.status == CreateOfferStatus.failure && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.errorMessage!}'), backgroundColor: Colors.red),
        );
      }
    });

    final isSubmitting = state.status == CreateOfferStatus.submitting;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicar Nueva Oferta'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              _buildTextField(
                label: 'Título del Puesto',
                onChanged: notifier.updateTitle,
                validator: (v) => v!.isEmpty ? 'El título es requerido.' : null,
              ),
              const SizedBox(height: 16),

              // Descripción
              _buildTextField(
                label: 'Descripción de la Oferta',
                onChanged: notifier.updateDescription,
                maxLines: 5,
                validator: (v) => v!.isEmpty ? 'La descripción es requerida.' : null,
              ),
              const SizedBox(height: 16),

              // Ubicación
              _buildTextField(
                label: 'Ubicación (Ej: Remoto, Madrid, Híbrido)',
                onChanged: notifier.updateLocation,
              ),
              const SizedBox(height: 16),

              // Tipo de Contrato (Dropdown)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Tipo de Contrato'),
                value: state.contractType,
                items: contractTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                onChanged: (value) => notifier.updateContractType(value!),
              ),
              const SizedBox(height: 20),
              
              Text('Rango Salarial (Anual Bruto)', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),

              // Salario Mínimo y Máximo
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Mínimo (K)',
                      keyboardType: TextInputType.number,
                      onChanged: notifier.updateMinSalary,
                      validator: (v) => v!.isEmpty ? 'Requerido.' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: 'Máximo (Opcional)',
                      keyboardType: TextInputType.number,
                      onChanged: notifier.updateMaxSalary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Botón de Envío
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : () {
                    if (formKey.currentState!.validate()) {
                      notifier.submitOffer();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: isSubmitting
                      ? const CircularProgressIndicator.adaptive(backgroundColor: Colors.white)
                      : const Text('Publicar Oferta', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para los TextFields
  Widget _buildTextField({
    required String label,
    required ValueChanged<String> onChanged,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      validator: validator,
    );
  }
}