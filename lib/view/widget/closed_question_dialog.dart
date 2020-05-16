import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClosedQuestionDialog extends StatelessWidget {
  final String title;
  final String message;
  final String positiveButtonTitle;
  final String negativeButtonTitle;
  final VoidCallback onPositiveButtonPressed;

  ClosedQuestionDialog(
      {@required this.title,
      @required this.message,
      @required this.positiveButtonTitle,
      @required this.negativeButtonTitle,
      @required this.onPositiveButtonPressed});

  Widget _androidAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text(positiveButtonTitle),
          onPressed: () => onPositiveButtonPressed(),
        ),
        FlatButton(
          child: Text(negativeButtonTitle),
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
          child: Text(positiveButtonTitle),
          onPressed: () => onPositiveButtonPressed(),
        ),
        CupertinoDialogAction(
          child: Text(negativeButtonTitle),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? _iOSAlertDialog(context)
        : _androidAlertDialog(context);
  }
}
