import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {

  final double minWidth;
  final String text;
  final Color backgroundColor;
  final VoidCallback onPressed;

  RoundButton({
    @required
    this.minWidth,
    @required
    this.text,
    @required
    this.backgroundColor,
    @required
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: minWidth,
      height: 60,
      child: RaisedButton(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white
          ),
        ),
        color: backgroundColor,
        shape: StadiumBorder(),
        onPressed: () => onPressed(),
      ),
    );
  }

}