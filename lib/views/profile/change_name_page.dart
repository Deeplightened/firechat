import 'package:firechat/common/extensions/context_extensions.dart';
import 'package:firechat/domain/repositories/user_repository.dart';
import 'package:firechat/common/configuration/injection.dart';
import 'package:firechat/models/response.dart';
import 'package:firechat/views/common/theme/styles.dart';
import 'package:firechat/views/common/validators.dart';
import 'package:firechat/views/profile/change_field_form.dart';
import 'package:flutter/material.dart';

class ChangeNamePage extends StatelessWidget {
  static Route<String> route(String name) {
    return MaterialPageRoute(builder: (_) => ChangeNamePage(name: name));
  }

  final TextEditingController _nameController = TextEditingController();

  ChangeNamePage({Key key, String name}) : super(key: key) {
    _nameController.text = name;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeFieldForm(
        child: _nameField(context),
        title: context.strings.nameChange,
        message: context.strings.nameChangeMessage,
        onValidate: _onNameValidated);
  }

  Widget _nameField(BuildContext context) => TextFormField(
      controller: _nameController,
      style: themeFieldContentTextStyle,
      decoration: createInputDecoration(),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      validator: createNotEmptyValidator(context));

  Future<Response> _onNameValidated() {
    return sl<UserRepository>().updateName(_nameController.text);
  }
}
