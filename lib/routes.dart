import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/view/screen/home_page.dart';
import 'package:inbear_app/view/screen/register_page.dart';
import 'package:inbear_app/view/screen/reset_password_page.dart';

class Routes {
  static const SplashPagePath = '/splash';
  static const LoginPagePath = '/login';
  static const ResetPasswordPagePath = '/reset_password';
  static const RegisterPagePath = '/register';
  static const HomePagePath = '/home';

  static void goToRegisterFromLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => RegisterPage(),
        fullscreenDialog: true
      )
    );
  }

  static void goToResetPasswordFromLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ResetPasswordPage(),
        fullscreenDialog: true
      )
    );
  }

  static void goToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomePage(),
          fullscreenDialog: true
        ),
        (_) => false);
  }

  static void goToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(LoginPagePath);
  }
}