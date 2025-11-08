import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // para que me pille el DateFormat
import '../../../../application/applicant/profile/user_profile_view_model.dart';

//el formato de fecha para mostrar al usuario
final _dateFormat = DateFormat('dd/MM/yyyy');

class ExperienceFormScreen extends ConsumerStatefulWidget {
  // Si 'experience' no es nulo, estamos en modo edición.
  final Experience? experience; 

  const ExperienceFormScreen({super.key, this.experience});

  @override
  ConsumerState<ExperienceFormScreen> createState() => _ExperienceFormScreenState();
}

class _ExperienceFormScreenState extends ConsumerState<ExperienceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores de texto
  late final TextEditingController _titleController;
  late final TextEditingController _companyController;
  late final TextEditingController _descriptionController;

  // Estados de fecha
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isCurrentJob = false;

  @override
  void initState() {
    super.initState();
    final isEditing = widget.experience != null;
    final exp = widget.experience;

    _titleController = TextEditingController(text: exp?.title ?? '');
    _companyController = TextEditingController(text: exp?.company ?? '');
    _descriptionController = TextEditingController(text: exp?.description ?? '');
    
    _startDate = exp?.startDate;
    _endDate = exp?.endDate;
    _isCurrentJob = isEditing && exp?.endDate == null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  // Función para abrir el selector de fecha
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  // Lógica de guardado (Añadir o Actualizar)
  void _saveExperience() {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La fecha de inicio es obligatoria.')),
      );
      return;
    }

    final profileNotifier = ref.read(userProfileViewModelProvider.notifier);
    
    // El objeto a guardar o actualizar
    final experienceToSave = Experience(
      id: widget.experience?.id ?? '', // Si es nuevo, el ID se generará en el backend
      title: _titleController.text,
      company: _companyController.text,
      startDate: _startDate!,
      endDate: _isCurrentJob ? null : _endDate,
      description: _descriptionController.text,
    );
    
    if (widget.experience != null) {
      // Modo Edición
      profileNotifier.updateExperience(experienceToSave);
    } else {
      // Modo Creación
      profileNotifier.addExperience(experienceToSave);
    }
    
    // Cerrar el formulario (modal) al finalizar la acción
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Observar el estado del perfil para saber si estamos guardando globalmente
    final isSaving = ref.watch(userProfileViewModelProvider).status == ProfileStatus.saving;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.experience == null ? 'Añadir Experiencia' : 'Editar Experiencia'),
        actions: [
          IconButton(
            icon: isSaving 
                ? const CircularProgressIndicator.adaptive() 
                : const Icon(Icons.save),
            onPressed: isSaving ? null : _saveExperience,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Título del Puesto
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título del Puesto'),
                validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 16),
              
              // Nombre de la Empresa
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: 'Nombre de la Empresa'),
                validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 24),

              // Fechas de Inicio y Fin
              Row(
                children: [
                  // Fecha de Inicio
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, true),
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Fecha de Inicio *'),
                        baseStyle: Theme.of(context).textTheme.titleMedium,
                        child: Text(
                          _startDate == null 
                              ? 'Seleccionar' 
                              : _dateFormat.format(_startDate!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Fecha de Fin
                  Expanded(
                    child: InkWell(
                      onTap: _isCurrentJob ? null : () => _selectDate(context, false),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Fecha de Fin',
                          enabled: !_isCurrentJob, // Deshabilitar si es trabajo actual
                        ),
                        baseStyle: Theme.of(context).textTheme.titleMedium,
                        child: Text(
                          _isCurrentJob
                              ? 'Actual'
                              : (_endDate == null ? 'Seleccionar' : _dateFormat.format(_endDate!)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Checkbox "Trabajo Actual"
              Row(
                children: [
                  Checkbox(
                    value: _isCurrentJob,
                    onChanged: (bool? value) {
                      setState(() {
                        _isCurrentJob = value ?? false;
                        if (_isCurrentJob) {
                          _endDate = null; // Limpiar fecha de fin si es actual
                        }
                      });
                    },
                  ),
                  const Text('Es mi trabajo actual'),
                ],
              ),
              const SizedBox(height: 24),
              
              // Descripción
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción de las responsabilidades/logros',
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}