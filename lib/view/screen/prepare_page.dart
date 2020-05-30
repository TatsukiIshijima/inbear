import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/routes.dart';
import 'package:inbear_app/view/widget/loading.dart';
import 'package:inbear_app/view/widget/logo.dart';

class PreparePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future<void>.delayed(Duration(milliseconds: 750));
      Routes.goToHome(context);
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Logo(
              fontSize: 80,
            ),
            const SizedBox(
              height: 20,
            ),
            Loading(),
            const SizedBox(height: 10),
            const Text(
              '設定中...',
              style: TextStyle(fontSize: 22),
            )
          ],
        ),
      ),
    );
  }
}
