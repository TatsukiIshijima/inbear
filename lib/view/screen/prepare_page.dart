import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/routes.dart';

class PreparePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future<void>.delayed(Duration(milliseconds: 500));
      Routes.goToHome(context);
    });
    return Scaffold(
      body: Center(
        child: Text('切り替え中...'),
      ),
    );
  }
}
