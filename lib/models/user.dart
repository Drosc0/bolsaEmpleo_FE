import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum UserRole {
  @JsonValue('ASPIRANTE')
  aspirante,
  @JsonValue('EMPRESA')
  empresa,
  @JsonValue('ADMIN')
  admin,
}

extension UserRoleExtension on UserRole {
  // Este método devuelve el valor de string que NestJS espera
  String toJson() {
    switch (this) {
      case UserRole.aspirante:
        return 'ASPIRANTE';
      case UserRole.empresa:
        return 'EMPRESA';
      case UserRole.admin:
        return 'ADMIN';
    }
  }
}

@JsonSerializable()
class User {
  final int id;
  final String email;
  final UserRole role;

  User({required this.id, required this.email, required this.role});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}