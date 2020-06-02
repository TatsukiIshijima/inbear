import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/view/screen/home_page.dart';
import 'package:inbear_app/view/screen/login_page.dart';
import 'package:inbear_app/view/screen/photo_preview_page.dart';
import 'package:inbear_app/view/screen/prepare_page.dart';
import 'package:inbear_app/view/screen/reset_password_page.dart';
import 'package:inbear_app/view/screen/schedule_register_page.dart';
import 'package:inbear_app/view/screen/schedule_select_page.dart';
import 'package:inbear_app/view/screen/user_register_page.dart';

class Routes {
  static const splashPagePath = '/';
  static const loginPagePath = '/login';
  static const resetPasswordPagePath = '/reset_password';
  static const registerPagePath = '/register';
  static const homePagePath = '/home';
  static const scheduleRegisterPagePath = '/schedule_register';

  static void goToRegisterFromLogin(BuildContext context) {
    Navigator.push<MaterialPageRoute>(
        context,
        MaterialPageRoute(
            builder: (context) => UserRegisterPage(), fullscreenDialog: true));
  }

  static void goToResetPasswordFromLogin(BuildContext context) {
    Navigator.push<MaterialPageRoute>(
        context,
        MaterialPageRoute(
            builder: (context) => ResetPasswordPage(), fullscreenDialog: true));
  }

  static void goToHome(BuildContext context) {
    Navigator.pushReplacement<MaterialPageRoute, MaterialPageRoute>(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(), fullscreenDialog: true));
  }

  static void goToLogin(BuildContext context) {
    Navigator.pushReplacement<MaterialPageRoute, MaterialPageRoute>(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(), fullscreenDialog: true));
  }

  static void goToLoginWhenLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil<MaterialPageRoute>(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(), fullscreenDialog: true),
        (_) => false);
  }

  static void goToScheduleRegister(BuildContext context) {
    Navigator.push<MaterialPageRoute>(
        context,
        MaterialPageRoute(
          builder: (context) => ScheduleRegisterPage(),
        ));
  }

  static void goToScheduleSelect(BuildContext context) {
    Navigator.push<MaterialPageRoute>(
        context, MaterialPageRoute(builder: (context) => ScheduleSelectPage()));
  }

  // スケジュールの切り替えはアプリ全体に影響があるので、ホーム画面更新のため、
  // 一旦ホーム前の適当な画面へ遷移させて、ホームへ再遷移させる
  static void goToPrepareWhenRegisterOrSelectSchedule(BuildContext context) {
    Navigator.pushAndRemoveUntil<MaterialPageRoute>(
        context,
        MaterialPageRoute(
            builder: (context) => PreparePage(), fullscreenDialog: true),
        (_) => false);
  }

  static void goToPhotoPreview(
      BuildContext context, DocumentSnapshot imageDocument) {
    Navigator.push<MaterialPageRoute>(
        context,
        MaterialPageRoute(
            builder: (context) => PhotoPreviewPage(imageDocument)));
  }
}
