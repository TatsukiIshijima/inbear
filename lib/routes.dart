import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/view/screen/home_page.dart';
import 'package:inbear_app/view/screen/login_page.dart';
import 'package:inbear_app/view/screen/photo_preview_page.dart';
import 'package:inbear_app/view/screen/reset_password_page.dart';
import 'package:inbear_app/view/screen/schedule_edit_page.dart';
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

  static Future<bool> goToScheduleRegister(BuildContext context) async {
    return await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ScheduleRegisterPage()));
  }

  static Future<bool> goToScheduleEdit(
      BuildContext context, ScheduleEntity scheduleEntity) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ScheduleEditPage(scheduleEntity)));
  }

  static Future<bool> goToScheduleSelect(BuildContext context) async {
    return await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ScheduleSelectPage()));
  }

  static Future<bool> goToPhotoPreview(BuildContext context,
      List<DocumentSnapshot> imageDocuments, int currentIndex) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PhotoPreviewPage(imageDocuments, currentIndex)));
  }
}
