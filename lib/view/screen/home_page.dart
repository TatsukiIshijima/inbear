import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/app_config_repository.dart';
import 'package:inbear_app/view/screen/album_page.dart';
import 'package:inbear_app/view/screen/base_page.dart';
import 'package:inbear_app/view/screen/participant_list_page.dart';
import 'package:inbear_app/view/screen/schedule_page.dart';
import 'package:inbear_app/view/screen/setting_page.dart';
import 'package:inbear_app/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage<HomeViewModel>(
      viewModel: HomeViewModel(
          Provider.of<AppConfigRepository>(context, listen: false)),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: AppBarTitle(),
        ),
        body: HomePageBody(),
        bottomNavigationBar: HomePageBottomNavigationBar(),
      ),
    );
  }
}

class AppBarTitle extends StatelessWidget {
  final List<String> _titleList = <String>['アルバム', 'スケジュール', '参加者', '設定'];

  @override
  Widget build(BuildContext context) {
    return Selector<HomeViewModel, int>(
      selector: (context, viewModel) => viewModel.selectIndex,
      builder: (context, index, child) => Text(_titleList[index]),
    );
  }
}

class HomePageBody extends StatelessWidget {
  final List<Widget> _pages = <Widget>[
    AlbumPage(),
    SchedulePage(),
    ParticipantListPage(),
    SettingPage()
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback(
        (_) async => await viewModel.loadFirstLaunchState());
    return Stack(
      children: <Widget>[
        PageView(
          controller: viewModel.pageController,
          onPageChanged: (index) => viewModel.updateIndex(index),
          children: _pages,
        ),
        Selector<HomeViewModel, bool>(
          selector: (context, viewModel) => viewModel.isFirstLaunchDone,
          builder: (context, isDone, child) =>
              isDone ? Container() : Tutorial(),
        )
      ],
    );
  }
}

class Tutorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    final viewModel = Provider.of<HomeViewModel>(context, listen: false);
    return Container(
        decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.3)),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12.0)),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () async =>
                          await viewModel.saveFirstLaunchState(),
                    )
                  ],
                ),
                Expanded(
                  child: PageView(
                    controller: viewModel.tutorialPageController,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 12),
                              child: AutoSizeText(
                                resource.introductionTitle,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                minFontSize: 16,
                                maxFontSize: 24,
                                style: TextStyle(
                                    color: Color(0xfff48fb1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 12),
                              child: AutoSizeText(
                                resource.introductionMessage,
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                minFontSize: 8,
                                maxFontSize: 12,
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Image.asset(
                                  'assets/icon/tutorial_icon_01.png',
                                  fit: BoxFit.cover,
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 12),
                              child: AutoSizeText(
                                resource.dearNewPairTitle,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                minFontSize: 16,
                                maxFontSize: 24,
                                style: TextStyle(
                                    color: Color(0xfff48fb1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 12),
                              child: AutoSizeText(
                                resource.dearNewPairMessage,
                                textAlign: TextAlign.center,
                                maxLines: 6,
                                minFontSize: 8,
                                maxFontSize: 12,
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Image.asset(
                                  'assets/tutorial_image_01.png',
                                  fit: BoxFit.cover,
                                  width: 240,
                                  height: 105,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 12),
                              child: AutoSizeText(
                                resource.dearOrdinaryPersonTitle,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                minFontSize: 16,
                                maxFontSize: 24,
                                style: TextStyle(
                                    color: Color(0xfff48fb1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 12),
                              child: AutoSizeText(
                                resource.dearOrdinaryPersonMessage,
                                textAlign: TextAlign.center,
                                maxLines: 6,
                                minFontSize: 8,
                                maxFontSize: 12,
                              ),
                            ),
                            Expanded(
                              child: Image.asset(
                                'assets/tutorial_image_02.png',
                                fit: BoxFit.cover,
                                width: 240,
                                height: 115,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: SmoothPageIndicator(
                    controller: viewModel.tutorialPageController,
                    count: 3,
                    effect: JumpingDotEffect(
                        dotWidth: 10,
                        dotHeight: 10,
                        activeDotColor: Color(0xfff48fb1)),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class HomePageBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context, listen: false);
    return Selector<HomeViewModel, int>(
      selector: (context, viewModel) => viewModel.selectIndex,
      builder: (context, index, child) {
        return BottomNavigationBar(
            selectedItemColor: Color(0xfff48fb1),
            unselectedItemColor: Colors.grey,
            currentIndex: index,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.collections), title: Text('アルバム')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.schedule), title: Text('スケジュール')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.people), title: Text('参加者')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), title: Text('設定'))
            ],
            onTap: (index) => viewModel.jumpToPage(index));
      },
    );
  }
}
