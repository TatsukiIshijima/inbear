import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/strings.dart';

class SingleButtonDialog extends StatelessWidget {

  final String title;
  final String message;

  SingleButtonDialog({
    this.title,
    this.message,
  });

  Widget _androidAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text(Strings.PositiveButtonTitle),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }

  Widget _iOSAlertDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(Strings.PositiveButtonTitle),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ?
      _iOSAlertDialog(context) :
      _androidAlertDialog(context);
  }
}