import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/view/widget/closed_question_dialog.dart';
import 'package:inbear_app/view/widget/title_icon_list_item.dart';
import 'package:inbear_app/viewmodel/setting_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../routes.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SettingViewModel(
        Provider.of<UserRepository>(context, listen: false)
      ),
      child: SettingPageContent(),
    );
  }
}

class SettingPageContent extends StatelessWidget {

  void _showLogoutDialog(BuildContext context, SettingViewModel viewModel) {
    var resource = AppLocalizations.of(context);
    showDialog(
        context: context,
        builder: (context) =>
          ClosedQuestionDialog(
            title: resource.logoutTitle,
            message: resource.logtoutMessage,
            positiveButtonTitle: resource.defaultPositiveButtonTitle,
            negativeButtonTitle: resource.defaultNegativeButtonTitle,
            onPositiveButtonPressed: () async {
              await viewModel.signOut();
              Routes.goToLoginWhenLogout(context);
            },
          )
    );
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<SettingViewModel>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TitleAndIconListItem(
            title: AppLocalizations.of(context).eventRegisterTitle,
            iconData: Icons.today,
            onTap: () {},
          ),
          TitleAndIconListItem(
            title: AppLocalizations.of(context).logoutTitle,
            iconData: Icons.exit_to_app,
            onTap: () => _showLogoutDialog(context, viewModel),
          )
        ],
      ),
    );;
  }
}