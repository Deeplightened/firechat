


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firechat/api/error_codes.dart';
import 'package:firechat/common/configuration/logger.dart';
import 'package:firechat/models/response.dart';

Future<Response<D>> callFirebaseService<D>(Future<D> Function() service) async {
  try {
    final result = await service();
    return Response.success(result);

  } on FirebaseException catch (error) {
    logger.e("Firebase exception occurred on api call", error.toString());
    return Response.error(firebaseErrorMapping[error.code] ?? ErrorCode.TECHNICAL_ERROR);

  } on Exception catch (error) {
    logger.e("Generic exception occurred on api call", error.toString());
    return Response.error(ErrorCode.TECHNICAL_ERROR);
  }
}

Map<String, ErrorCode> firebaseErrorMapping = {
  "requires-recent-login": ErrorCode.RECENT_LOGIN_REQUIRED,
  "email-already-in-use": ErrorCode.EMAIL_ALREADY_IN_USE,
  "wrong-password": ErrorCode.WRONG_PASSWORD,
  "network-request-failed": ErrorCode.NETWORK_ERROR,
  "quota-exceeded": ErrorCode.QUOTA_EXCEEDED,
  "timeout": ErrorCode.TIMEOUT_ERROR,
  "user-token-expired": ErrorCode.TOKEN_EXPIRED,
  "user-not-found": ErrorCode.USER_NOT_FOUND
};