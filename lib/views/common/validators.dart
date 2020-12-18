import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firechat/common/extensions/context_extensions.dart';

String Function(String) createMultiValidators(
        List<String Function(String)> validators) =>
    (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };

String Function(String) createEmailValidator(BuildContext context) => (value) {
      if (!EmailValidator.validate(value)) {
        return context.strings.errorEmailInvalid;
      }
      return null;
    };


String Function(String) createPasswordNotEmptyValidator(BuildContext context) =>
        (value) {
      if (value == null || value.isEmpty) {
        return context.strings.errorPasswordEmpty;
      }
      return null;
    };

String Function(String) createPasswordValidValidator(BuildContext context) =>
    (value) {
      if (value == null || value.length < 8) {
        return context.strings.errorPasswordInvalid;
      }
      return null;
    };

String Function(String) createPasswordConfirmValidator(
        BuildContext context, TextEditingController controller) =>
    (value) {
      if (value != controller.text) {
        return context.strings.errorPasswordNotMatching;
      }
      return null;
    };

String Function(String) createNotEmptyValidator(BuildContext context) =>
    (value) {
      if (value == null || value.isEmpty) {
        return context.strings.errorFieldEmpty;
      }
      return null;
    };
