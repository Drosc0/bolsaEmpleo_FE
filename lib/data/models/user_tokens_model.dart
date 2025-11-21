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
      accessToken: json['access_token'] as String, 
      userId: json['user']['id'] as int,
      userRole: json['user']['role'] as String,
    );
  }
}