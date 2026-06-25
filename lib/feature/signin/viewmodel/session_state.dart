class SessionState {
  final bool isAuthenticated;
  final String? sessionId;
  final int? accountId;
  final String? username;

  const SessionState({
    this.isAuthenticated = false,
    this.sessionId,
    this.accountId,
    this.username,
  });

  factory SessionState.initial() => const SessionState();

  SessionState copyWith({
    bool? isAuthenticated,
    String? sessionId,
    int? accountId,
    String? username,
    bool clearSession = false,
  }) {
    if (clearSession) {
      return SessionState.initial();
    }
    return SessionState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      sessionId: sessionId ?? this.sessionId,
      accountId: accountId ?? this.accountId,
      username: username ?? this.username,
    );
  }
}
