import 'package:bolsa_empleo/data/models/job_offer_model.dart';
import 'package:flutter/material.dart';

class OfferCard extends StatelessWidget {
  final JobOffer offer;
  final VoidCallback? onTap;

  const OfferCard({super.key, required this.offer, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      // CardTheme esta app_theme.dart
      child: InkWell(
        borderRadius: BorderRadius.circular(16), // CardTheme radius
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Text(
                offer.title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Empresa y Ubicación
              _buildInfoRow(
                context,
                icon: Icons.business,
                text: offer.companyName,
              ),
              const SizedBox(height: 4),

              // Ubicación, donde te van a encerrar
              _buildInfoRow(
                context,
                icon: Icons.location_on,
                text: offer.location,
              ),
              const SizedBox(height: 4),

              // Rango Salarial, para la caridad
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  offer.salaryRange,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).hintColor),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
