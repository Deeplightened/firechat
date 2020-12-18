
import 'package:firechat/common/extensions/context_extensions.dart';
import 'package:firechat/domain/blocs/session/session_bloc.dart';
import 'package:firechat/domain/blocs/session/session_state.dart';
import 'package:firechat/domain/blocs/simple_state.dart';
import 'package:firechat/domain/repositories/auth_repository.dart';
import 'package:firechat/domain/repositories/user_repository.dart';
import 'package:firechat/common/configuration/injection.dart';
import 'package:firechat/models/user_profile.dart';
import 'package:firechat/views/common/theme/colors.dart';
import 'package:firechat/views/common/theme/styles.dart';
import 'package:firechat/views/common/widgets/error_panel.dart';
import 'package:firechat/views/common/widgets/primary_button.dart';
import 'package:firechat/views/profile/change_email_page.dart';
import 'package:firechat/views/profile/change_name_page.dart';
import 'package:firechat/views/profile/change_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final ImagePicker picker = ImagePicker();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  SimpleState state = SimpleState.idle();
  UserProfile user;

  UserRepository get _userRepository => sl();
  AuthRepository get _authRepository => sl();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<SessionBloc, SessionState>(
          builder: (context, sessionState) {
        if (sessionState.status != SessionStatus.authenticated)
          return Container();

        return StreamBuilder<UserProfile>(
            stream: _userRepository.getUserProfile(sessionState.userId),
            builder: (context, snapshot) {
              user = snapshot.data;

              return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // AVATAR
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: (user?.picture == null)
                            ? _emptyUserPicture
                            : _userPicture(user.picture),
                      ),

                      // NAME
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: _nameField,
                      ),

                      // EMAIL
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: _emailField,
                      ),

                      // PASSWORD
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: _passwordField,
                      ),

                      // ERROR PANEL
                      if (state.errorCode != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ErrorCodePanel(errorCode: state.errorCode),
                        ),

                      // DISCONNECT
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child:
                            (state.loading) ? Container() : _disconnectButton,
                      )
                    ],
                  ));
            });
      }),
    );
  }

  Widget _userPicture(String pictureUrl) => SizedBox(
      height: 100,
      width: 100,
      child: CircleAvatar(backgroundImage: NetworkImage(pictureUrl)));

  Widget get _nameField => ProfileFormField(
      value: user?.name, icon: Icons.account_circle, callback: _doUpdateName);

  Widget get _emailField => ProfileFormField(
      value: user?.email, icon: Icons.email, callback: _doUpdateEmail);

  Widget get _passwordField => ProfileFormField(
        value: context.strings.passwordChange,
        icon: Icons.lock,
        callback: _doUpdatePassword,
      );

  Widget get _emptyUserPicture => InkWell(
        customBorder: CircleBorder(),
        onTap: _doOpenImagePicker,
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
          child: Center(
            child: Text("?", style: TextStyle(fontSize: 50)),
          ),
        ),
      );

  Widget get _disconnectButton => PrimaryButton(
      color: themeErrorColor,
      onClick: (context) {
        _doDisconnectUser();
      },
      label: context.strings.disconnect);

  _doUpdateName() async {
    Navigator.of(context).push(ChangeNamePage.route(user?.name));
  }

  _doUpdateEmail() async {
    Navigator.of(context).push(ChangeEmailPage.route(user?.email));
  }

  _doUpdatePassword() async {
    Navigator.of(context).push(ChangePasswordPage.route());
  }

  _doOpenImagePicker() async {
    final PickedFile imageFile =
        await widget.picker.getImage(source: ImageSource.gallery);
    if (imageFile != null) {
      await _userRepository.updateUserPicture(imageFile.path);
    }
  }

  _doDisconnectUser() async {
    setState(() {
      state = SimpleState.loading();
    });

    final response = await _authRepository.logOut();

    setState(() {
      state = response.toSimpleState();
    });
  }
}

class ProfileFormField extends StatelessWidget {
  final String value;
  final IconData icon;
  final GestureTapCallback callback;

  const ProfileFormField({Key key, this.value, this.icon, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: themeTextColor))),
      child: ListTile(
        leading: Icon(icon, color: themeTextColor),
        title: Text(
          value ?? "",
          style: themeFieldContentTextStyle,
        ),
        onTap: callback,
      ),
    );
  }
}
