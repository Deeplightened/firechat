import 'package:firebase_auth/firebase_auth.dart';
import 'package:firechat/api/firebase/common_functions.dart';
import 'package:firechat/models/requests/auth_requests.dart';
import 'package:firechat/models/response.dart';

class FirebaseAuthApi {
  User get currentUser => FirebaseAuth.instance.currentUser;

  Future<Response<String>> signInWithEmailAndPassword(
          SignInEmailRequest request) =>
      callFirebaseService(() async {
        final response = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: request.email, password: request.password);
        return response.user.uid;
      });

  Future<Response<String>> createUserWithEmailAndPassword(
          CreateAccountRequest request) =>
      callFirebaseService(() async {
        final response = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: request.email, password: request.password);
        return response.user.uid;
      });

  Future<Response<bool>> signOut() =>
      callFirebaseService(() => FirebaseAuth.instance.signOut());

  Future<Response<bool>> updateEmail(String userId, String newEmail) =>
      _callUserService((currentUser) => currentUser.updateEmail(newEmail));

  Future<Response<bool>> updatePassword(String userId, String newPassword) =>
      _callUserService(
          (currentUser) => currentUser.updatePassword(newPassword));

  Future<Response<bool>> reAuthenticateUserWithEmail(
          String userId, String password) =>
      _callUserService((currentUser) =>
          currentUser.reauthenticateWithCredential(EmailAuthProvider.credential(
              email: currentUser.email, password: password)));


  // PRIVATE METHODS

  Future<Response<bool>> _callUserService(Future Function(User) callback) =>
      callFirebaseService(() async {
        final currentUser = FirebaseAuth.instance.currentUser;
        await callback(currentUser);
        return true;
      });
}
