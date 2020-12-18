import 'package:flutter/cupertino.dart';

class SignInEmailRequest {
  final String email;
  final String password;

  SignInEmailRequest({@required this.email, @required this.password})
      : assert(email != null),
        assert(password != null);
}

class CreateAccountRequest {
  final String name;
  final String email;
  final String password;

  CreateAccountRequest(
      {@required this.name, @required this.email, @required this.password})
      : assert(name != null),
        assert(email != null),
        assert(password != null);
}
