import 'dart:async';

import 'package:firechat/common/configuration/logger.dart';
import 'package:firechat/domain/blocs/session/session_event.dart';
import 'package:firechat/domain/blocs/session/session_state.dart';
import 'package:firechat/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  StreamSubscription<String> _userSubscription;

  SessionBloc(AuthRepository repository) : super(const SessionState.idle()) {
    // Listen to current auth user in order to inform an authentication state change
    _userSubscription = repository.getAuthUserId().listen((userId) {
      logger.d("Bloc received user update : ${userId}");
      add(SessionChangedEvent(userId));
    });
  }

  @override
  Stream<SessionState> mapEventToState(SessionEvent event) async* {
    if (event is SessionChangedEvent) {
      if (event.userId != null) {
        logger.d("User authenticated : ${event.userId}");
        yield SessionState.authenticated(event.userId);
      } else {
        logger.d("User unauthenticated");
        yield SessionState.unauthenticated();
      }
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
