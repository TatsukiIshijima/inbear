import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/view/screen/album_page.dart';
import 'package:inbear_app/view/screen/base_page.dart';
import 'package:inbear_app/view/screen/participant_list_page.dart';
import 'package:inbear_app/view/screen/schedule_page.dart';
import 'package:inbear_app/view/screen/setting_page.dart';
import 'package:inbear_app/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage<HomeViewModel>(
      viewModel: HomeViewModel(),
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
    return PageView(
      controller: viewModel.pageController,
      onPageChanged: (index) => viewModel.updateIndex(index),
      children: _pages,
    );
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
