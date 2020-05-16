import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {
  final double fontSize;

  Logo({this.fontSize});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: [
        TextSpan(
          text: 'in',
          style: GoogleFonts.portLligatSans(
              textStyle: Theme.of(context).textTheme.display1,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.pinkAccent),
        ),
        TextSpan(
            text: 'bear',
            style: GoogleFonts.portLligatSans(
                textStyle: Theme.of(context).textTheme.display1,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.pink[100]))
      ]),
    );
  }
}
