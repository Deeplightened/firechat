

class SessionState {
  final String userId;
  final SessionStatus status;

  const SessionState._({this.userId, this.status});

  const SessionState.idle(): this._(status: SessionStatus.idle);

  const SessionState.authenticated(String userId): this._(userId: userId, status: SessionStatus.authenticated);

  const SessionState.unauthenticated(): this._(status: SessionStatus.unauthenticated);
}

enum SessionStatus {
  idle, authenticated, unauthenticated
}