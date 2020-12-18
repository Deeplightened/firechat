
import 'package:firechat/domain/blocs/simple_state.dart';
import 'package:firechat/domain/repositories/auth_repository.dart';
import 'package:firechat/models/user_profile.dart';
import 'package:firechat/models/requests/auth_requests.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateAccountCubit extends Cubit<SimpleState<bool>> {

  final AuthRepository _repository;

  CreateAccountCubit(this._repository): super(SimpleState.idle());

  
  createAccountWithCredentials(CreateAccountRequest request) async {
    emit(SimpleState.loading());

    final result = await _repository.createAccount(request);

    if(result.hasError) emit(SimpleState.error(result.errorCode));
    else emit(SimpleState.success(result.data));
  }
}