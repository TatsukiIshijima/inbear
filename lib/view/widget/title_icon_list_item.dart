import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitleAndIconListItem extends StatelessWidget {

  final String title;
  final IconData iconData;
  final VoidCallback onTap;

  TitleAndIconListItem({
    @required
    this.title,
    @required
    this.iconData,
    @required
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        child: Container(
          padding: EdgeInsets.all(24.0),
          child: Row(
            children: <Widget>[
              Icon(
                iconData,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18
                ),
              )
            ],
          ),
        ),
        onTap: () => onTap(),
      ),
    );
  }

}