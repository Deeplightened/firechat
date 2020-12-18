import 'package:firechat/common/extensions/context_extensions.dart';
import 'package:firechat/domain/repositories/user_repository.dart';
import 'package:firechat/common/configuration/injection.dart';
import 'package:firechat/models/response.dart';
import 'package:firechat/views/common/theme/styles.dart';
import 'package:firechat/views/common/validators.dart';
import 'package:firechat/views/profile/change_field_form.dart';
import 'package:flutter/material.dart';

class ChangeEmailPage extends StatelessWidget {

  static Route<String> route(String name) {
    return MaterialPageRoute(builder: (_) => ChangeEmailPage(email: name));
  }

  final TextEditingController _emailController = TextEditingController();

  ChangeEmailPage({Key key, String email}) : super(key: key) {
    _emailController.text = email;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeFieldForm(
        child: _emailField(context),
        title: context.strings.emailChange,
        message: context.strings.emailChangeMessage,
        onValidate: _onEmailValidated);
  }

  Widget _emailField(BuildContext context) => TextFormField(
      controller: _emailController,
      style: themeFieldContentTextStyle,
      decoration: createInputDecoration(),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      validator: createNotEmptyValidator(context));
  

  Future<Response> _onEmailValidated() {
    return sl<UserRepository>().updateEmail(_emailController.text);
  }
}
