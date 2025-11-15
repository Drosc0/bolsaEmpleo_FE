import 'package:bolsa_empleo/application/common/home_state.dart';
import 'package:bolsa_empleo/application/company/company_home_view_model.dart';
import 'package:flutter/material.dart';

class _OffersList extends StatelessWidget {
  final CompanyHomeState state;
  const _OffersList({required this.state});

  @override
  Widget build(BuildContext context) {
    return switch (state.status) {
      HomeStatus.loading => const Center(child: CircularProgressIndicator()),
      HomeStatus.error => Center(child: Text(state.errorMessage ?? '')),
      _ => state.data.isEmpty
          ? const Center(child: Text('Sin ofertas'))
          : ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (_, i) {
                final o = state.data[i];
                return ListTile(
                  title: Text(o.title),
                  subtitle: Text('${o.totalApplications} aplicaciones'),
                  trailing: Chip(label: Text('${o.newApplications} nuevas')),
                );
              },
            ),
    };
  }
}