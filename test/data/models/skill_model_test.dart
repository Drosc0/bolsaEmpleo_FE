import 'package:flutter_test/flutter_test.dart';
import 'package:bolsa_empleo/data/models/skill_model.dart';

void main() {
  group('Skill Model Test', () {
    // Test para verificar que el modelo se crea correctamente desde un JSON
    test('fromJson creates a valid Skill object', () {
      final json = {'id': 1, 'name': 'Flutter'};
      final skill = Skill.fromJson(json);

      expect(skill.id, 1);
      expect(skill.name, 'Flutter');
    });

    // Test para verificar que el modelo se convierte correctamente a JSON
    test('toJson returns a valid Map', () {
      final skill = Skill(id: 1, name: 'Flutter');
      final json = skill.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'Flutter');
    });

    // Test para verificar el comportamiento cuando el id es nulo
    test('toJson handles null id correctly', () {
      final skill = Skill(name: 'Dart');
      final json = skill.toJson();

      expect(json.containsKey('id'), false);
      expect(json['name'], 'Dart');
    });
  });
}
