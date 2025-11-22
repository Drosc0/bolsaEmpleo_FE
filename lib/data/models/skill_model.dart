class Skill {
  final int? id;
  final String name;

  Skill({this.id, required this.name});

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(id: json['id'] as int?, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id, 'name': name};
  }
}
