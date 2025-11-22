import 'job_offer_model.dart';

class Application {
  final int id;
  final JobOffer jobOffer;
  final String status;
  final DateTime appliedAt;

  Application({
    required this.id,
    required this.jobOffer,
    required this.status,
    required this.appliedAt,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'] as int,
      jobOffer: JobOffer.fromJson(json['jobOffer'] as Map<String, dynamic>),
      status: json['status'] as String,
      appliedAt: DateTime.parse(json['appliedAt'] as String),
    );
  }
}
