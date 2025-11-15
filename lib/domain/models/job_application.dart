import 'package:equatable/equatable.dart';

/// Modelo de dominio para una postulación (aplicación) de un aspirante a una oferta.
class JobApplication extends Equatable {
  final String id;
  final String jobOfferId;
  final String applicantId;
  final String jobTitle;      // ← NUEVO (viene del DTO)
  final String companyName;   // ← NUEVO (viene del DTO)
  final String status;        // Ej: 'Enviada', 'Revisada', 'Entrevista', 'Aceptada', 'Rechazada'
  final DateTime appliedAt;

  const JobApplication({
    required this.id,
    required this.jobOfferId,
    required this.applicantId,
    required this.jobTitle,
    required this.companyName,
    required this.status,
    required this.appliedAt,
  });

  // -------------------------------------------------
  // FACTORY: fromJson (compatible con JobApplicationDto)
  // -------------------------------------------------
  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id'] as String,
      jobOfferId: json['job_offer_id'] as String,
      applicantId: json['applicant_id'] as String? ?? '',
      jobTitle: json['job_title'] as String? ?? 'Oferta sin título',
      companyName: json['company_name'] as String? ?? 'Empresa desconocida',
      status: json['status'] as String,
      appliedAt: DateTime.parse(json['applied_at'] as String),
    );
  }

  // -------------------------------------------------
  // toJson (para pruebas o envío al backend)
  // -------------------------------------------------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_offer_id': jobOfferId,
      'applicant_id': applicantId,
      'job_title': jobTitle,
      'company_name': companyName,
      'status': status,
      'applied_at': appliedAt.toIso8601String(),
    };
  }

  // -------------------------------------------------
  // copyWith (inmutabilidad)
  // -------------------------------------------------
  JobApplication copyWith({
    String? id,
    String? jobOfferId,
    String? applicantId,
    String? jobTitle,
    String? companyName,
    String? status,
    DateTime? appliedAt,
  }) {
    return JobApplication(
      id: id ?? this.id,
      jobOfferId: jobOfferId ?? this.jobOfferId,
      applicantId: applicantId ?? this.applicantId,
      jobTitle: jobTitle ?? this.jobTitle,
      companyName: companyName ?? this.companyName,
      status: status ?? this.status,
      appliedAt: appliedAt ?? this.appliedAt,
    );
  }

  // -------------------------------------------------
  // Equatable (equals & hashCode)
  // -------------------------------------------------
  @override
  List<Object?> get props => [
        id,
        jobOfferId,
        applicantId,
        jobTitle,
        companyName,
        status,
        appliedAt,
      ];

  @override
  String toString() {
    return 'JobApplication(id: $id, jobOfferId: $jobOfferId, '
        'applicantId: $applicantId, jobTitle: $jobTitle, '
        'companyName: $companyName, status: $status, '
        'appliedAt: $appliedAt)';
  }
}