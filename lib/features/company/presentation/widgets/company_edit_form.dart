import 'package:flutter/material.dart';

class _CreateOfferButton extends StatelessWidget {
  final VoidCallback onCreate;
  const _CreateOfferButton({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        onPressed: onCreate,
        icon: const Icon(Icons.add),
        label: const Text('Crear Nueva Oferta'),
      ),
    );
  }
}