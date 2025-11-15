import 'package:flutter/material.dart';

class _CreateOfferDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  const _CreateOfferDialog({required this.onSubmit});

  @override
  State<_CreateOfferDialog> createState() => _CreateOfferDialogState();
}

class _CreateOfferDialogState extends State<_CreateOfferDialog> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _location = TextEditingController();
  final _minSalary = TextEditingController();
  final _contractType = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva Oferta'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(controller: _location, decoration: const InputDecoration(labelText: 'Ubicación')),
              const SizedBox(height: 8),
              TextFormField(
                controller: _minSalary,
                decoration: const InputDecoration(labelText: 'Salario mínimo'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextFormField(controller: _contractType, decoration: const InputDecoration(labelText: 'Tipo de contrato (ej: Indefinido)')),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit({
                'title': _title.text,
                'location': _location.text,
                'minSalary': int.tryParse(_minSalary.text) ?? 0,
                'maxSalary': (int.tryParse(_minSalary.text) ?? 0) + 5000,
                'contractType': _contractType.text,
                'description': 'Oferta creada desde Flutter',
              });
            }
          },
          child: const Text('Publicar'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _location.dispose();
    _minSalary.dispose();
    _contractType.dispose();
    super.dispose();
  }
}