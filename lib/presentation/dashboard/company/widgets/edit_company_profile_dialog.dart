import 'package:flutter/material.dart';

import '../../../../data/models/company_profile_model.dart';
import '../viewmodel/company_dashboard_view_model.dart';

class EditCompanyProfileDialog extends StatefulWidget {
  final CompanyProfile profile;
  final CompanyDashboardViewModel viewModel;

  const EditCompanyProfileDialog({
    super.key,
    required this.profile,
    required this.viewModel,
  });

  @override
  State<EditCompanyProfileDialog> createState() =>
      _EditCompanyProfileDialogState();
}

class _EditCompanyProfileDialogState extends State<EditCompanyProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _websiteController;
  late TextEditingController _locationController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.companyName);
    _descriptionController = TextEditingController(
      text: widget.profile.description,
    );
    _websiteController = TextEditingController(text: widget.profile.website);
    _locationController = TextEditingController(text: widget.profile.location);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final viewModel = widget.viewModel;
      await viewModel.updateCompanyProfile({
        'companyName': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'website': _websiteController.text.trim(),
        'location': _locationController.text.trim(),
      });

      if (mounted) {
        Navigator.of(context).pop(); // Cerrar diálogo
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado correctamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al actualizar: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Modificar Datos de Empresa',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),

                TextFormField(
                  initialValue: widget.profile.email ?? '',
                  decoration: const InputDecoration(
                    labelText: 'Email (No modificable)',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  readOnly: true,
                  enabled: false,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la Empresa',
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _websiteController,
                  decoration: const InputDecoration(labelText: 'Sitio Web'),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Ubicación'),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveChanges,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Guardar Cambios'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
