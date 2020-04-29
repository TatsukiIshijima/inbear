import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/view/screen/home_page.dart';
import 'package:inbear_app/view/screen/login_page.dart';
import 'package:inbear_app/view/screen/register_page.dart';
import 'package:inbear_app/view/screen/reset_password_page.dart';
import 'package:inbear_app/view/screen/schedule_register_page.dart';

class Routes {
  static const SplashPagePath = '/';
  static const LoginPagePath = '/login';
  static const ResetPasswordPagePath = '/reset_password';
  static const RegisterPagePath = '/register';
  static const HomePagePath = '/home';
  static const ScheduleRegisterPagePath = '/schedule_register';

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
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => HomePage(),
            fullscreenDialog: true
        )
    );
  }

  static void goToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LoginPage(),
        fullscreenDialog: true
      )
    );
  }

  static void goToLoginWhenLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => LoginPage(),
            fullscreenDialog: true
        ),
            (_) => false);
  }

  static void goToScheduleRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScheduleRegisterPage(),
      )
    );
  }
}