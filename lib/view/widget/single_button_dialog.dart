import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleButtonDialog extends StatelessWidget {

  final String title;
  final String message;
  final String positiveButtonTitle;
  final VoidCallback onPressed;

  SingleButtonDialog({
    this.title,
    this.message,
    this.positiveButtonTitle,
    this.onPressed,
  });

  Widget _androidAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text(positiveButtonTitle),
          onPressed: () => onPressed(),
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
          child: Text(positiveButtonTitle),
          onPressed: () => onPressed(),
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