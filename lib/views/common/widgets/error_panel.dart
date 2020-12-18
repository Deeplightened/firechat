import 'package:firechat/api/error_codes.dart';
import 'package:firechat/views/common/theme/colors.dart';
import 'package:firechat/views/common/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:firechat/common/extensions/context_extensions.dart';

class ErrorCodePanel extends StatelessWidget {

  final ErrorCode errorCode;

  const ErrorCodePanel({Key key, this.errorCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: themeErrorBackgroundColor,
          borderRadius: BorderRadius.circular(themeDefaultRadius)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          _errorCodeWordings(context),
          style: TextStyle(color: themeErrorTextColor, fontSize: 16.0),
        ),
      ),
    );
  }

  String _errorCodeWordings(BuildContext context) {
    switch (errorCode) {
      case ErrorCode.EMAIL_ALREADY_IN_USE:
        return context.strings.serviceErrorEmailAlreadyInUse;
      case ErrorCode.WRONG_PASSWORD:
        return context.strings.serviceErrorWrongPassword;
      case ErrorCode.NETWORK_ERROR:
        return context.strings.serviceErrorNetworkRequestFailed;
      case ErrorCode.QUOTA_EXCEEDED:
        return context.strings.serviceErrorQuotaExceeded;
      case ErrorCode.USER_NOT_FOUND:
        return context.strings.serviceErrorUserNotFound;
      default:
        return context.strings.serviceErrorUnknown;
    }
  }
}
