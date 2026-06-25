class AuthSessionModel {
  final String sessionId;
  final int accountId;
  final String username;

  const AuthSessionModel({
    required this.sessionId,
    required this.accountId,
    required this.username,
  });
}
