import 'dart:async';

import 'package:firechat/common/configuration/logger.dart';
import 'package:firechat/domain/repositories/auth_repository.dart';
import 'package:firechat/domain/repositories/user_repository.dart';
import 'package:firechat/models/user_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<UserProfile> {
  StreamSubscription<UserProfile> _userSubscription;

  ProfileCubit(UserRepository repository, String userId) : super(null) {
    _userSubscription = repository.getUserProfile(userId).listen((user) {
      logger.d("Bloc received user update : $userId");
      emit(user);
    });
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
