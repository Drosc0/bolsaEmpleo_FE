import 'package:dio/dio.dart';

// --------------------------------------------------------------------------
// 1. Modelos (DTOs) - Actualizados y completos
// --------------------------------------------------------------------------

class JobOfferDto {
  final String id;
  final String title;
  final String company;
  final String location;
  final String contractType;
  final int minSalary;
  final int maxSalary;
  final String description;
  final String postedDate;

  JobOfferDto({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.contractType,
    required this.minSalary,
    required this.maxSalary,
    required this.description,
    required this.postedDate,
  });

  factory JobOfferDto.fromJson(Map<String, dynamic> json) => JobOfferDto(
        id: json['id'] as String,
        title: json['title'] as String,
        company: json['company_name'] as String? ?? 'Empresa Desconocida',
        location: json['location'] as String? ?? 'N/A',
        contractType: json['contract_type'] as String? ?? 'N/A',
        minSalary: (json['min_salary'] as num?)?.toInt() ?? 0,
        maxSalary: (json['max_salary'] as num?)?.toInt() ?? 0,
        description: json['description'] as String? ?? '',
        postedDate: json['posted_date'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'company_name': company,
        'location': location,
        'contract_type': contractType,
        'min_salary': minSalary,
        'max_salary': maxSalary,
        'description': description,
        'posted_date': postedDate,
      };
}

class PostedJobOfferDto {
  final String id;
  final String title;
  final String description;
  final String location;
  final String contractType;
  final int minSalary;
  final int maxSalary;
  final String createdAt;
  final int totalApplications;
  final int newApplications;

  PostedJobOfferDto({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.contractType,
    required this.minSalary,
    required this.maxSalary,
    required this.createdAt,
    required this.totalApplications,
    required this.newApplications,
  });

  factory PostedJobOfferDto.fromJson(Map<String, dynamic> json) => PostedJobOfferDto(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        location: json['location'] as String? ?? 'N/A',
        contractType: json['contract_type'] as String? ?? 'N/A',
        minSalary: (json['min_salary'] as num?)?.toInt() ?? 0,
        maxSalary: (json['max_salary'] as num?)?.toInt() ?? 0,
        createdAt: json['created_at'] as String,
        totalApplications: (json['total_applications'] as num?)?.toInt() ?? 0,
        newApplications: (json['new_applications'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'location': location,
        'contract_type': contractType,
        'min_salary': minSalary,
        'max_salary': maxSalary,
        'created_at': createdAt,
        'total_applications': totalApplications,
        'new_applications': newApplications,
      };
}

class JobApplicationDto {
  final String id;
  final String jobOfferId;
  final String jobTitle;
  final String companyName;
  final String status;
  final String appliedAt;

  JobApplicationDto({
    required this.id,
    required this.jobOfferId,
    required this.jobTitle,
    required this.companyName,
    required this.status,
    required this.appliedAt,
  });

  factory JobApplicationDto.fromJson(Map<String, dynamic> json) => JobApplicationDto(
        id: json['id'] as String,
        jobOfferId: json['job_offer_id'] as String,
        jobTitle: json['job_title'] as String? ?? 'Título Desconocido',
        companyName: json['company_name'] as String? ?? 'N/A',
        status: json['status'] as String,
        appliedAt: json['applied_at'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'job_offer_id': jobOfferId,
        'job_title': jobTitle,
        'company_name': companyName,
        'status': status,
        'applied_at': appliedAt,
      };
}

class ApplicantDetailDto {
  final String applicantId;
  final String name;
  final String email;
  final String applicationStatus;
  final String appliedAt;

  ApplicantDetailDto({
    required this.applicantId,
    required this.name,
    required this.email,
    required this.applicationStatus,
    required this.appliedAt,
  });

  factory ApplicantDetailDto.fromJson(Map<String, dynamic> json) => ApplicantDetailDto(
        applicantId: json['applicant_id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        applicationStatus: json['application_status'] as String,
        appliedAt: json['applied_at'] as String,
      );

  Map<String, dynamic> toJson() => {
        'applicant_id': applicantId,
        'name': name,
        'email': email,
        'application_status': applicationStatus,
        'applied_at': appliedAt,
      };
}

// --------------------------------------------------------------------------
// 2. Servicio API
// --------------------------------------------------------------------------

class JobOffersApiService {
  final Dio _dio;

  JobOffersApiService(this._dio) {
    _dio.options.baseUrl = 'http://localhost:3000/api';
  }

  Future<List<JobOfferDto>> getRecommendedOffers(String userId) async {
    final response = await _dio.get('/offers/recommended', queryParameters: {'userId': userId});
    return (response.data as List).map((json) => JobOfferDto.fromJson(json)).toList();
  }

  Future<List<PostedJobOfferDto>> getPostedOffers(String companyId) async {
    final response = await _dio.get('/company/offers', queryParameters: {'companyId': companyId});
    return (response.data as List).map((json) => PostedJobOfferDto.fromJson(json)).toList();
  }

  Future<List<JobApplicationDto>> getAppliedOffers(String userId) async {
    final response = await _dio.get('/offers/applied', queryParameters: {'userId': userId});
    return (response.data as List).map((json) => JobApplicationDto.fromJson(json)).toList();
  }

  Future<void> createJobOffer({
    required String companyId,
    required String title,
    required String description,
    required String location,
    required String contractType,
    required int minSalary,
    required int maxSalary,
  }) async {
    await _dio.post('/company/offers', data: {
      'companyId': companyId,
      'title': title,
      'description': description,
      'location': location,
      'contract_type': contractType,
      'min_salary': minSalary,
      'max_salary': maxSalary,
    });
  }

  Future<List<ApplicantDetailDto>> getApplicantsByOffer(String jobOfferId) async {
    final response = await _dio.get('/offers/$jobOfferId/applicants');
    return (response.data as List).map((json) => ApplicantDetailDto.fromJson(json)).toList();
  }

  Future<void> updateApplicationStatus({
    required String applicationId,
    required String newStatus,
  }) async {
    await _dio.patch('/applications/$applicationId', data: {'status': newStatus});
  }
}