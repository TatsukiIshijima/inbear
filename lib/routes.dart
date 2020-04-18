import 'package:flutter/cupertino.dart';

class Routes {
  static const SplashPagePath = '/splash';
  static const LoginPagePath = '/login';
  static const RegisterPagePath = '/register';

  static void goToRegisterFromLogin(BuildContext context) {
    Navigator.of(context).pushNamed(RegisterPagePath);
  }

  static void backToLoginFromRegister(BuildContext context) {
    Navigator.of(context).pop();
  }
}