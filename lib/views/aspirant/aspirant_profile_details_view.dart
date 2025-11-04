import 'package:flutter/material.dart';
import '../../models/aspirant_profile.dart';

class AspirantProfileDetailsView extends StatelessWidget {
  final AspirantProfile profile;

  const AspirantProfileDetailsView({required this.profile, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CV: ${profile.name}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Datos Básicos ---
            _buildHeader(context, 'Información de Contacto', Icons.contact_mail),
            Text('Email: ${profile.email}', style: const TextStyle(fontSize: 16)),
            Text('Teléfono: ${profile.phone ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            // --- Resumen Profesional ---
            _buildHeader(context, 'Resumen Profesional', Icons.description),
            Text(profile.summary ?? 'El aspirante no proporcionó un resumen profesional.', 
                 style: const TextStyle(fontStyle: FontStyle.italic)),
            const SizedBox(height: 30),

            // --- Habilidades ---
            _buildHeader(context, 'Habilidades Clave', Icons.star),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: profile.skills.map((s) => Chip(
                label: Text('${s.name} (${s.level})', style: const TextStyle(fontWeight: FontWeight.w500)),
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              )).toList(),
            ),
            if (profile.skills.isEmpty) const Text('Sin habilidades listadas.'),
            const SizedBox(height: 30),

            // --- Experiencia Laboral ---
            _buildHeader(context, 'Experiencia Laboral', Icons.work),
            ...profile.experience.map((exp) => Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exp.title, style: Theme.of(context).textTheme.titleMedium),
                  Text('${exp.company} (${exp.location})', style: const TextStyle(fontStyle: FontStyle.italic)),
                  Text('${_formatDate(exp.startDate)} - ${_formatDate(exp.endDate)}'),
                  if (exp.description != null && exp.description!.isNotEmpty) 
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(exp.description!),
                    ),
                ],
              ),
            )).toList(),
            if (profile.experience.isEmpty) const Text('Sin experiencia laboral listada.'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 10.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Actual';
    return '${date.month}/${date.year}';
  }
}