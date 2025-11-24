import 'package:flutter/material.dart';

import '../../../../data/models/profile_model.dart';
import '../../../../data/models/skill_model.dart';
import '../../../../data/models/experience_model.dart';
import '../viewmodel/applicant_dashboard_view_model.dart';

class EditApplicantProfileDialog extends StatefulWidget {
  final Profile profile;
  final ApplicantDashboardViewModel viewModel;

  const EditApplicantProfileDialog({
    super.key,
    required this.profile,
    required this.viewModel,
  });

  @override
  State<EditApplicantProfileDialog> createState() =>
      _EditApplicantProfileDialogState();
}

class _EditApplicantProfileDialogState
    extends State<EditApplicantProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _linkedinController;
  late TextEditingController _portfolioController;

  // Listas para guardar tus cosas mientras editas.
  late List<Skill> _skills;
  late List<Experience> _experience;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.profile.firstName,
    );
    _lastNameController = TextEditingController(text: widget.profile.lastName);
    _phoneController = TextEditingController(text: widget.profile.phone);
    _linkedinController = TextEditingController(
      text: widget.profile.linkedinUrl,
    );
    _portfolioController = TextEditingController(
      text: widget.profile.portfolioUrl,
    );

    // Initialize lists from profile
    _skills = List.from(widget.profile.skills);
    _experience = List.from(widget.profile.experience);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _linkedinController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  void _addSkill(String name) {
    setState(() {
      _skills.add(Skill(name: name));
    });
  }

  void _removeSkill(Skill skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  void _addExperience(Experience exp) {
    setState(() {
      _experience.add(exp);
    });
  }

  void _removeExperience(Experience exp) {
    setState(() {
      _experience.remove(exp);
    });
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Usamos el viewModel que nos pasan, para no liarla con el contexto.
      final viewModel = widget.viewModel;

      // Empaquetamos todo para mandarlo al servidor.
      final profileData = {
        'phone': _phoneController.text.trim(),
        'linkedinUrl': _linkedinController.text.trim(),
        'portfolioUrl': _portfolioController.text.trim(),
        'skills': _skills.map((s) => s.toJson()).toList(),
        'experience': _experience.map((e) => e.toJson()).toList(),
      };

      await viewModel.updateProfile(profileData);

      if (mounted) {
        Navigator.of(context).pop();
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
      child: DefaultTabController(
        length: 3,
        child: Container(
          width: 600,
          height: 700,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                'Modificar Perfil',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              const TabBar(
                tabs: [
                  Tab(text: 'Datos Personales'),
                  Tab(text: 'Experiencia'),
                  Tab(text: 'Habilidades'),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: TabBarView(
                    children: [
                      // Tab 1: Quien eres. (Aunque el email y nombre no se tocan).
                      SingleChildScrollView(
                        child: Column(
                          children: [
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
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _firstNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Nombre (No modificable)',
                                      prefixIcon: Icon(Icons.lock_outline),
                                    ),
                                    readOnly: true,
                                    enabled: false,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _lastNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Apellido (No modificable)',
                                      prefixIcon: Icon(Icons.lock_outline),
                                    ),
                                    readOnly: true,
                                    enabled: false,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Teléfono',
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _linkedinController,
                              decoration: const InputDecoration(
                                labelText: 'LinkedIn URL',
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _portfolioController,
                              decoration: const InputDecoration(
                                labelText: 'Portfolio URL',
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Tab 2: Donde has currado.
                      Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: _experience.length,
                              itemBuilder: (context, index) {
                                final exp = _experience[index];
                                return Card(
                                  child: ListTile(
                                    title: Text(exp.title),
                                    subtitle: Text(
                                      '${exp.company} (${exp.startDate.year})',
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _removeExperience(exp),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final result = await showDialog<Experience>(
                                context: context,
                                builder: (context) =>
                                    const _AddExperienceDialog(),
                              );
                              if (result != null) {
                                _addExperience(result);
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Añadir Experiencia'),
                          ),
                        ],
                      ),

                      // Tab 3: Lo que sabes hacer.
                      Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _skills.map((skill) {
                                  return Chip(
                                    label: Text(skill.name),
                                    onDeleted: () => _removeSkill(skill),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Nueva Habilidad',
                                    hintText: 'Ej: Flutter, Dart, SQL',
                                  ),
                                  onSubmitted: (value) {
                                    if (value.isNotEmpty) {
                                      _addSkill(value);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            'Presiona Enter para añadir',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
    );
  }
}

class _AddExperienceDialog extends StatefulWidget {
  const _AddExperienceDialog();

  @override
  State<_AddExperienceDialog> createState() => _AddExperienceDialogState();
}

class _AddExperienceDialogState extends State<_AddExperienceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Añadir Experiencia'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Cargo'),
                validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: 'Empresa'),
                validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  'Fecha Inicio: ${_startDate.day}/${_startDate.month}/${_startDate.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) setState(() => _startDate = date);
                },
              ),
              ListTile(
                title: Text(
                  _endDate == null
                      ? 'Fecha Fin: Actualidad'
                      : 'Fecha Fin: ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _endDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) setState(() => _endDate = date);
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(
                context,
                Experience(
                  title: _titleController.text,
                  company: _companyController.text,
                  startDate: _startDate,
                  endDate: _endDate,
                  description: _descriptionController.text,
                ),
              );
            }
          },
          child: const Text('Añadir'),
        ),
      ],
    );
  }
}
