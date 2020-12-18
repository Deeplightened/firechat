

class SessionEvent {
  const SessionEvent();
}

class SessionChangedEvent extends SessionEvent {
  final String userId;

  const SessionChangedEvent(this.userId): super();
}