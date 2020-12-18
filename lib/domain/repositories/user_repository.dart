import 'package:firechat/models/response.dart';
import 'package:firechat/models/user_profile.dart';

abstract class UserRepository {
  Stream<UserProfile> getUserProfile(String userId);

  Future<Response<bool>> updateName(String name);

  Future<Response<bool>> updateEmail(String email);

  Future<Response<bool>> updatePassword(String oldPassword, String newPassword);

  Future<Response<bool>> updateUserPicture(String pictureFilePath);
}
