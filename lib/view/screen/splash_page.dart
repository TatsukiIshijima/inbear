import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/routes.dart';
import 'package:inbear_app/view/widget/logo.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatelessWidget {

  void _goToTargetPage(BuildContext context, bool isSignIn) {
    Timer(Duration(seconds: 3), () {
      if (isSignIn) {
        Routes.goToHome(context);
      } else {
        Routes.goToLogin(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 画面描画後にログイン済かの判定処理を実行
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var isSignIn = await Provider.of<UserRepository>(context, listen: false).isSignIn();
      _goToTargetPage(context, isSignIn);
    });
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Center(
        child: Logo(fontSize: 100,),
      ),
    );
  }

}