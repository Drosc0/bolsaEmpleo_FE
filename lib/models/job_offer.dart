import 'package:json_annotation/json_annotation.dart';

part 'job_offer.g.dart';

@JsonSerializable()
class JobOffer {
  final int id;
  final String title;
  final String description;
  final String location;
  final double salary;
  final DateTime postedAt;
  
  // Asumimos que la API devuelve el nombre de la empresa como parte de la oferta
  final String companyName; 
  
  // Lista de requisitos
  final List<String>? requirements; 
  
  // Contador de postulantes (útil en CompanyHomeView)
  final int? applicationsCount; 

  JobOffer({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.salary,
    required this.postedAt,
    required this.companyName,
    this.requirements, 
    this.applicationsCount,
  });

  factory JobOffer.fromJson(Map<String, dynamic> json) => _$JobOfferFromJson(json);
  Map<String, dynamic> toJson() => _$JobOfferToJson(this);
}