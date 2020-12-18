import 'package:firechat/models/user_profile.dart';
import 'package:firechat/models/requests/auth_requests.dart';
import 'package:firechat/models/response.dart';

abstract class AuthRepository {
  Future<Response<bool>> signInWithEmail(SignInEmailRequest request);

  Future<Response<bool>> createAccount(CreateAccountRequest request);

  Stream<String> getAuthUserId();

  Future<Response<bool>> logOut();
}
