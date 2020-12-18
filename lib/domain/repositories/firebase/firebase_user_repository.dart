


import 'package:firechat/api/firebase/auth_api.dart';
import 'package:firechat/api/firebase/user_storage.dart';
import 'package:firechat/api/firebase/user_store.dart';
import 'package:firechat/common/configuration/logger.dart';
import 'package:firechat/domain/repositories/user_repository.dart';
import 'package:firechat/models/response.dart';
import 'package:firechat/models/user_profile.dart';

class FirebaseUserRepository extends UserRepository {

  final FirebaseAuthApi _authApi;
  final FirebaseUserStore _userStore;
  final FirebaseUserStorage _userStorage;

  FirebaseUserRepository(this._authApi, this._userStore, this._userStorage);

  @override
  Stream<UserProfile> getUserProfile(String userId) {
    return _userStore.listen(userId);
  }

  @override
  Future<Response<bool>> updateName(String name) {
    logger.d("updateName : $name");
    final userId = _authApi.currentUser.uid;
    return _userStore.update(userId, {UserProfile.NAME_KEY: name});
  }

  @override
  Future<Response<bool>> updateEmail(String email) async {
    logger.d("updateEmail : $email");
    final userId = _authApi.currentUser.uid;

    final authResponse = await _authApi.updateEmail(userId, email);
    if (authResponse.hasError) return Response.error(authResponse.errorCode);

    final storeResponse =
    await _userStore.update(userId, {UserProfile.EMAIL_KEY: email});
    if (storeResponse.hasError) return Response.error(storeResponse.errorCode);

    return Response.success(true);
  }

  @override
  Future<Response<bool>> updatePassword(
      String oldPassword, String newPassword) async {
    logger.d("updatePassword : $oldPassword - $newPassword");
    final userId = _authApi.currentUser.uid;

    final oldPasswordResponse =
    await _authApi.reAuthenticateUserWithEmail(userId, oldPassword);
    if (oldPasswordResponse.hasError)
      return Response.error(oldPasswordResponse.errorCode);

    final newPasswordResponse =
    await _authApi.updatePassword(userId, newPassword);
    if (newPasswordResponse.hasError)
      return Response.error(newPasswordResponse.errorCode);

    return Response.success(true);
  }

  @override
  Future<Response<bool>> updateUserPicture(String pictureFilePath) async {
    logger.d("updateUserPicture");
    final userId = _authApi.currentUser.uid;

    final storageResponse =
    await _userStorage.add(userId, pictureFilePath);
    if (storageResponse.hasError)
      return Response.error(storageResponse.errorCode);

    final storeResponse = await _userStore
        .update(userId, {UserProfile.PICTURE_KEY: storageResponse.data});
    if (storeResponse.hasError) return Response.error(storeResponse.errorCode);

    return Response.success(true);
  }

}