class Experience {
  final int? id;
  final String title;
  final String company;
  final DateTime startDate;
  final DateTime? endDate;
  final String description;

  Experience({
    this.id,
    required this.title,
    required this.company,
    required this.startDate,
    this.endDate,
    required this.description,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'] as int?,
      title: json['title'] as String,
      company: json['company'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'company': company,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'description': description,
    };
  }
}
