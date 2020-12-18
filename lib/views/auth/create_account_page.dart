import 'package:firechat/api/error_codes.dart';
import 'package:firechat/common/extensions/context_extensions.dart';
import 'package:firechat/domain/blocs/simple_state.dart';
import 'package:firechat/common/configuration/injection.dart';
import 'package:firechat/models/requests/auth_requests.dart';
import 'package:firechat/views/auth/create_account_cubit.dart';
import 'package:firechat/views/auth/login_page.dart';
import 'package:firechat/views/common/theme/colors.dart';
import 'package:firechat/views/common/validators.dart';
import 'package:firechat/views/common/widgets/form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/theme/constants.dart';
import '../common/theme/styles.dart';
import '../common/widgets/error_panel.dart';
import '../common/widgets/primary_button.dart';
import '../common/widgets/secondary_button.dart';

class CreateAccountPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute(builder: (_) => CreateAccountPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeBackgroundColor,
      body: SingleChildScrollView(
        child: BlocProvider<CreateAccountCubit>(
            create: (_) => CreateAccountCubit(sl()),
            child: _CreateAccountForm()),
      ),
    );
  }
}

class _CreateAccountForm extends StatefulWidget {

  @override
  _CreateAccountFormState createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<_CreateAccountForm> {

  static const NAME_KEY = "name";
  static const EMAIL_KEY = "email";
  static const PASSWORD_KEY = "password";

  final _formKey = GlobalKey<FormState>();
  final _formValues = Map<String, dynamic>();
  final _passwordController = TextEditingController();

  ErrorCode errorCode;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAccountCubit, SimpleState<bool>>(
        builder: (context, snapshot) {
      errorCode = snapshot.errorCode;
      loading = snapshot.loading;

      return Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // ICON
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: _icon,
                  ),

                  // ERROR PANEL
                  (errorCode == null)
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ErrorCodePanel(errorCode: errorCode),
                        ),

                  // EMAIL
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: _emailField,
                  ),

                  // NAME
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: _nameField,
                  ),

                  // PASSWORD
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: _passwordField,
                  ),

                  // CONFIRM PASSWORD
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: _confirmPasswordField,
                  ),

                  // CREATE ACCOUNT
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: (loading) ? _loadingButton : _createAccountButton,
                  ),

                  // ALREADY SIGNED
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: (loading) ? Container() : _alreadyAccountButton,
                  )
                ],
              )));
    });
  }

  Widget get _icon => ClipRRect(
        borderRadius: BorderRadius.circular(themeDefaultRadius),
        child: Image.asset("assets/images/logo_firebase.png",
            width: 160, height: 160),
      );

  Widget get _emailField => CustomFormField(
        label: context.strings.email,
        child: TextFormField(
            style: themeFieldContentTextStyle,
            decoration: createInputDecoration(),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: createMultiValidators([
              createNotEmptyValidator(context),
              createEmailValidator(context)
            ]),
            onSaved: (value) {
              _formValues[EMAIL_KEY] = value;
            }),
      );

  Widget get _nameField => CustomFormField(
        label: context.strings.name,
        child: TextFormField(
            style: themeFieldContentTextStyle,
            decoration: createInputDecoration(),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            validator: createNotEmptyValidator(context),
            onSaved: (value) {
              _formValues[NAME_KEY] = value;
            }),
      );

  Widget get _passwordField => CustomFormField(
        label: context.strings.password,
        child: TextFormField(
            style: themeFieldContentTextStyle,
            decoration: createInputDecoration(),
            controller: _passwordController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            obscureText: true,
            validator: createMultiValidators([
              createPasswordNotEmptyValidator(context),
              createPasswordValidValidator(context),
            ]),
            onSaved: (value) {
              _formValues[PASSWORD_KEY] = value;
            }),
      );

  Widget get _confirmPasswordField => CustomFormField(
        label: context.strings.confirmPassword,
        child: TextFormField(
            style: themeFieldContentTextStyle,
            decoration: createInputDecoration(),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            obscureText: true,
            validator:
                createPasswordConfirmValidator(context, _passwordController),
            onEditingComplete: (){
              _doCreateAccount();
            },),
      );

  Widget get _createAccountButton => PrimaryButton(
      onClick: (context) {
        _doCreateAccount();
      },
      label: context.strings.createAccount);

  Widget get _alreadyAccountButton => SecondaryButton(
      onClick: (context) {
        Navigator.of(context).pushReplacement(LoginPage.route());
      },
      label: context.strings.alreadyHaveAccount);

  Widget get _loadingButton => PrimaryButton(
      onClick: (context) {},
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation(themeTextColor),
      ));


  _doCreateAccount() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      BlocProvider.of<CreateAccountCubit>(context).createAccountWithCredentials(
          CreateAccountRequest(
              name: _formValues[NAME_KEY],
              email: _formValues[EMAIL_KEY],
              password: _formValues[PASSWORD_KEY],
          ));
    }
  }
}
