import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Label extends StatelessWidget {

  final String text;
  final IconData iconData;

  Label({
    @required
    this.text,
    @required
    this.iconData
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                iconData,
                color: Colors.black54,
              ),
              SizedBox(width: 8,),
              Text(
                text,
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
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