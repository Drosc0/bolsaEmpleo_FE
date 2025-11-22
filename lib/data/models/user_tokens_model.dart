class UserTokens {
  final String accessToken;
  final int userId;
  final String userRole; // Pa saber si es 'aspirante' o 'empresa'

  UserTokens({
    required this.accessToken,
    required this.userId,
    required this.userRole,
  });

  factory UserTokens.fromJson(Map<String, dynamic> json) {
    return UserTokens(
      accessToken: json['token'] as String,
      userId: json['userId'] as int,
      userRole: json['role'] as String,
    );
  }
}
