import 'job_offer_model.dart';
import 'profile_model.dart';

class Application {
  final int id;
  final JobOffer jobOffer;
  final String status;
  final DateTime appliedAt;
  final Profile? applicant;

  Application({
    required this.id,
    required this.jobOffer,
    required this.status,
    required this.appliedAt,
    this.applicant,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'] as int,
      jobOffer: JobOffer.fromJson(json['jobOffer'] as Map<String, dynamic>),
      status: json['status'] as String,
      appliedAt: DateTime.parse(json['appliedAt'] as String),
      applicant: json['aspirantProfile'] != null
          ? Profile.fromJson(json['aspirantProfile'] as Map<String, dynamic>)
          : null,
    );
  }
}
