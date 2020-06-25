import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/view/screen/base_page.dart';
import 'package:inbear_app/view/widget/default_dialog.dart';
import 'package:inbear_app/view/widget/title_icon_list_item.dart';
import 'package:inbear_app/viewmodel/home_viewmodel.dart';
import 'package:inbear_app/viewmodel/setting_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../routes.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BasePage<SettingViewModel>(
      viewModel:
          SettingViewModel(Provider.of<UserRepository>(context, listen: false)),
      // HomeでScaffoldを使用しているのでその中身のみをchildとする
      child: SettingPageContent(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SettingPageContent extends StatelessWidget {
  void _showLogoutDialog(BuildContext context, AppLocalizations resource,
      Future<dynamic> Function() future) {
    showDialog<DefaultDialog>(
        context: context,
        builder: (context) => DefaultDialog(
              resource.logoutTitle,
              resource.logoutMessage,
              positiveButtonTitle: resource.defaultPositiveButtonTitle,
              negativeButtonTitle: resource.defaultNegativeButtonTitle,
              onPositiveButtonPressed: () async {
                await future();
                Routes.goToLoginWhenLogout(context);
              },
              onNegativeButtonPressed: () {},
            ));
  }

  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    final viewModel = Provider.of<SettingViewModel>(context, listen: false);
    // 親のHomeViewModelを使用して、スケジュール切り替え画面で切り替えた際に
    // 画面遷移（戻る）で更新フラグを受け取り、スケジュールが切り替わったことを
    // HomeViewのフラグを更新して BottomNavigationBar の各画面に伝える
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // ListTile の場合、メールアドレスがアイコンの方まで伸びてくるので、
          // カスタムレイアウトを使用
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: const Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  resource.userTitle,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Container(
                      child: FutureBuilder<String>(
                    future: viewModel.fetchUserEmail(),
                    builder: (context, snapshot) {
                      var email = '';
                      if (snapshot.hasData) {
                        email = snapshot.data;
                      }
                      return AutoSizeText(
                        email,
                        maxLines: 1,
                        maxFontSize: 18,
                        minFontSize: 16,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      );
                    },
                  )),
                )
              ],
            ),
          ),
          TitleAndIconListItem(
            title: resource.scheduleSelectTitle,
            iconData: Icons.compare_arrows,
            onTap: () async {
              final isSelectScheduleChanged =
                  await Routes.goToScheduleSelect(context);
              if (isSelectScheduleChanged != null && isSelectScheduleChanged) {
                homeViewModel.updateSelectScheduleChangedFlag();
              }
            },
          ),
          TitleAndIconListItem(
            title: resource.licenseTitle,
            iconData: Icons.library_books,
            onTap: () => showLicensePage(context: context),
          ),
          TitleAndIconListItem(
            title: resource.logoutTitle,
            iconData: Icons.exit_to_app,
            onTap: () =>
                _showLogoutDialog(context, resource, () => viewModel.signOut()),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(12.0),
            child: ListTile(
              title: Text(resource.versionTitle),
              trailing: Text('1.0.0'),
            ),
          )
        ],
      ),
    );
  }
}
