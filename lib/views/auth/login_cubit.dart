

import 'package:firechat/domain/blocs/simple_state.dart';
import 'package:firechat/domain/repositories/auth_repository.dart';
import 'package:firechat/models/user_profile.dart';
import 'package:firechat/models/requests/auth_requests.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<SimpleState<bool>> {

  final AuthRepository _repository;

  LoginCubit(this._repository): super(SimpleState.idle());

  signInWithCredentials(SignInEmailRequest request) async {
    emit(SimpleState.loading());
    
    final result = await _repository.signInWithEmail(request);
    
    if(result.hasError) emit(SimpleState.error(result.errorCode));
    else emit(SimpleState.success(result.data));
  }
}