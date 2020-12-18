import 'package:firechat/common/extensions/context_extensions.dart';
import 'package:firechat/domain/repositories/auth_repository.dart';
import 'package:firechat/domain/repositories/user_repository.dart';
import 'package:firechat/common/configuration/injection.dart';
import 'package:firechat/models/response.dart';
import 'package:firechat/views/common/theme/styles.dart';
import 'package:firechat/views/common/validators.dart';
import 'package:firechat/views/common/widgets/form_field.dart';
import 'package:firechat/views/profile/change_field_form.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatelessWidget {

  static Route<String> route() {
    return MaterialPageRoute(builder: (_) => ChangePasswordPage());
  }

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeFieldForm(
        child: _passwordFields(context),
        title: context.strings.passwordChange,
        message: context.strings.passwordChangeMessage,
        onValidate: _onPasswordValidated);
  }

  Widget _passwordFields(BuildContext context) => Column(
        children: [
          // OLD PASSWORD
          _oldPasswordField(context),

          // NEW PASSWORD
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: _newPasswordField(context),
          ),

          // CONFIRM PASSWORD
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: _confirmPasswordField(context),
          )
        ],
      );

  Widget _oldPasswordField(BuildContext context) => CustomFormField(
        label: context.strings.oldPassword,
        child: TextFormField(
            style: themeFieldContentTextStyle,
            decoration: createInputDecoration(),
            controller: _oldPasswordController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            obscureText: true,
            validator: createPasswordNotEmptyValidator(context)),
      );

  Widget _newPasswordField(BuildContext context) => CustomFormField(
        label: context.strings.newPassword,
        child: TextFormField(
            style: themeFieldContentTextStyle,
            decoration: createInputDecoration(),
            controller: _newPasswordController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            obscureText: true,
            validator: createMultiValidators([
              createPasswordNotEmptyValidator(context),
              createPasswordValidValidator(context),
            ])),
      );

  Widget _confirmPasswordField(BuildContext context) => CustomFormField(
        label: context.strings.confirmPassword,
        child: TextFormField(
            style: themeFieldContentTextStyle,
            decoration: createInputDecoration(),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            obscureText: true,
            validator: createPasswordConfirmValidator(
                context, _newPasswordController)),
      );

  Future<Response> _onPasswordValidated() {
    return sl<UserRepository>().updatePassword(
        _oldPasswordController.text, _newPasswordController.text);
  }
}
