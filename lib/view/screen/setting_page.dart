import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/view/widget/title_icon_list_item.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TitleAndIconListItem(
            title: AppLocalizations.of(context).eventRegisterTitle,
            iconData: Icons.today,
          ),
          TitleAndIconListItem(
            title: AppLocalizations.of(context).logoutTitle,
            iconData: Icons.exit_to_app,
          )
        ],
      ),
    );
  }
}