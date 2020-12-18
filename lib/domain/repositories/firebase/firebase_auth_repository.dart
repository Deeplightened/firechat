import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firechat/api/error_codes.dart';
import 'package:firechat/api/firebase/auth_api.dart';
import 'package:firechat/api/firebase/user_storage.dart';
import 'package:firechat/api/firebase/user_store.dart';
import 'package:firechat/common/configuration/logger.dart';
import 'package:firechat/domain/repositories/auth_repository.dart';
import 'package:firechat/models/user_profile.dart';
import 'package:firechat/models/requests/auth_requests.dart';
import 'package:firechat/models/response.dart';

class FirebaseAuthRepository extends AuthRepository {
  final FirebaseAuthApi _authApi;
  final FirebaseUserStore _userStore;

  FirebaseAuthRepository(this._authApi, this._userStore);

  @override
  Future<Response<bool>> signInWithEmail(
      SignInEmailRequest request) async {
    if (request == null || request.email == null || request.password == null)
      return Response.error(ErrorCode.TECHNICAL_ERROR);

    final apiResponse = await _authApi.signInWithEmailAndPassword(request);
    if (apiResponse.hasError) return Response.error(apiResponse.errorCode);

    final storeResponse = await _userStore.get(apiResponse.data);
    if (storeResponse.hasError) return Response.error(storeResponse.errorCode);

    return Response.success(true);
  }

  @override
  Future<Response<bool>> createAccount(
      CreateAccountRequest request) async {
    final apiResponse = await _authApi.createUserWithEmailAndPassword(request);
    if (!apiResponse.hasData) return Response.error(apiResponse.errorCode);

    final appUser = UserProfile(
        id: apiResponse.data, name: request.name, email: request.email);

    final storeResponse = await _userStore.createNew(appUser);
    if (!storeResponse.hasData) return Response.error(storeResponse.errorCode);

    return Response.success(true);
  }

  @override
  Stream<String> getAuthUserId() {
    return FirebaseAuth.instance.authStateChanges().map((authState) {
      logger.d("Firebase auth state is : $authState");
      return authState?.uid;
    });
  }


  @override
  Future<Response<bool>> logOut() async {
    return _authApi.signOut();
  }
}
