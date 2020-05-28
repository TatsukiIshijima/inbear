import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/view/screen/base_page.dart';
import 'package:inbear_app/view/widget/closed_question_dialog.dart';
import 'package:inbear_app/view/widget/title_icon_list_item.dart';
import 'package:inbear_app/viewmodel/setting_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../routes.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      viewModel:
          SettingViewModel(Provider.of<UserRepository>(context, listen: false)),
      // HomeでScaffoldを使用しているのでその中身のみをchildとする
      child: SettingPageContent(),
    );
  }
}

class SettingPageContent extends StatelessWidget {
  void _showLogoutDialog(BuildContext context, AppLocalizations resource,
      Future<dynamic> Function() future) {
    showDialog<ClosedQuestionDialog>(
        context: context,
        builder: (context) => ClosedQuestionDialog(
              title: resource.logoutTitle,
              message: resource.logoutMessage,
              positiveButtonTitle: resource.defaultPositiveButtonTitle,
              negativeButtonTitle: resource.defaultNegativeButtonTitle,
              onPositiveButtonPressed: () async {
                await future();
                Routes.goToLoginWhenLogout(context);
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    final viewModel = Provider.of<SettingViewModel>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TitleAndIconListItem(
            title: resource.scheduleRegisterTitle,
            iconData: Icons.today,
            onTap: () => Routes.goToScheduleRegister(context),
          ),
          TitleAndIconListItem(
            title: resource.scheduleSelectTitle,
            iconData: Icons.compare_arrows,
            onTap: () => Routes.goToScheduleSelect(context),
          ),
          TitleAndIconListItem(
            title: resource.logoutTitle,
            iconData: Icons.exit_to_app,
            onTap: () =>
                _showLogoutDialog(context, resource, () => viewModel.signOut()),
          )
        ],
      ),
    );
  }
}
