import 'package:firechat/api/error_codes.dart';
import 'package:firechat/common/extensions/context_extensions.dart';
import 'package:firechat/domain/blocs/simple_state.dart';
import 'package:firechat/common/configuration/injection.dart';
import 'package:firechat/models/requests/auth_requests.dart';
import 'package:firechat/views/auth/create_account_page.dart';
import 'package:firechat/views/auth/login_cubit.dart';
import 'package:firechat/views/common/theme/colors.dart';
import 'package:firechat/views/common/theme/constants.dart';
import 'package:firechat/views/common/theme/styles.dart';
import 'package:firechat/views/common/validators.dart';
import 'package:firechat/views/common/widgets/error_panel.dart';
import 'package:firechat/views/common/widgets/form_field.dart';
import 'package:firechat/views/common/widgets/primary_button.dart';
import 'package:firechat/views/common/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LoginPage extends StatelessWidget {

  static Route route() {
    return MaterialPageRoute(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeBackgroundColor,
      body: SingleChildScrollView(
        child: BlocProvider<LoginCubit>(
          create: (_) => LoginCubit(sl()),
          child: LoginForm()
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  static const EMAIL_KEY = "email";
  static const PASSWORD_KEY = "password";

  final _formKey = GlobalKey<FormState>();
  final _formValues = Map<String, dynamic>();

  ErrorCode errorCode;
  bool loading;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, SimpleState<bool>>(
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
                  (errorCode == null) ? Container() : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ErrorCodePanel(errorCode: errorCode),
                  ),

                  // EMAIL
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: _emailField,
                  ),

                  // PASSWORD
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: _passwordField,
                  ),

                  // SIGN IN
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: (loading) ? _loadingButton : _signInButton,
                  ),

                  // CREATE ACCOUNT
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: (loading) ? Container() : _createAccountButton,
                  )
                ],
              ),
            ));
      }
    );
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
              createEmailValidator(context),
            ]),
            onSaved: (value) {
              _formValues[EMAIL_KEY] = value;
            }),
      );

  Widget get _passwordField => CustomFormField(
        label: context.strings.password,
        child: TextFormField(
            style: themeFieldContentTextStyle,
            decoration: createInputDecoration(),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            textInputAction: TextInputAction.done,
            validator: createNotEmptyValidator(context),
            onEditingComplete: () {
              _doLogin();
            },
            onSaved: (value) {
              _formValues[PASSWORD_KEY] = value;
            }),
      );

  Widget get _signInButton => PrimaryButton(
      onClick: (context) {
        _doLogin();
      },
      label: context.strings.signIn);

  Widget get _createAccountButton => SecondaryButton(
      onClick: (context) {
        Navigator.of(context).pushReplacement(CreateAccountPage.route());
      },
      label: context.strings.noAccount);


  Widget get _loadingButton => PrimaryButton(
      onClick: (context) {}, child: CircularProgressIndicator(
    strokeWidth: 3,
    valueColor: AlwaysStoppedAnimation(themeTextColor),
  ));


  _doLogin() {
    if (_formKey.currentState.validate() && !loading) {
      _formKey.currentState.save();
      BlocProvider.of<LoginCubit>(context).signInWithCredentials(
          SignInEmailRequest(
              email: _formValues[EMAIL_KEY],
              password: _formValues[PASSWORD_KEY]
          )
      );
    }
  }
}
