import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Label extends StatelessWidget {

  final String text;

  Label({
    @required
    this.text
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              fontSize: 20
            ),
          ),
          Divider(
            thickness: 2,
            color: Color(0xfff48fb1),
          ),
        ],
      ),
    );
  }

}