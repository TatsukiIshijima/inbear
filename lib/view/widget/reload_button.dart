import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/localize/app_localizations.dart';

class ReloadButton extends StatelessWidget {
  final Function() onPressed;

  ReloadButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            resource.timeoutError,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            onPressed: () => onPressed(),
            child: Text(
              resource.reloadMessage,
              style: TextStyle(color: Color(0xfff48fb1)),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                side: BorderSide(color: Color(0xfff48fb1))),
          )
        ],
      ),
    );
  }
}
