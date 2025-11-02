/// @brief Modelo para habilidades, idiomas o herramientas de un aspirante.
class SkillItem {
  final String name;
  final String category; // Ej: 'Técnica', 'Blanda', 'Idioma'
  final String level; // Ej: 'Avanzado', 'B2', 'Experto'

  SkillItem({
    required this.name,
    required this.category,
    required this.level,
  });

  factory SkillItem.fromJson(Map<String, dynamic> json) {
    return SkillItem(
      name: json['name'] as String,
      category: json['category'] as String,
      level: json['level'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'level': level,
    };
  }
}