import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/strings.dart';
import 'package:inbear_app/view/widget/title_icon_list_item.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TitleAndIconListItem(
            title: Strings.EventRegisterTitle,
            iconData: Icons.today,
          ),
          TitleAndIconListItem(
            title: Strings.LogoutTitle,
            iconData: Icons.exit_to_app,
          )
        ],
      ),
    );
  }
}