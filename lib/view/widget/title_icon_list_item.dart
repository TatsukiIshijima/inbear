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
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(12.0),
        child: ListTile(
          leading: Icon(iconData),
          title: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis
          ),
        ),
      ),
      onTap: () => onTap(),
    );
  }

}