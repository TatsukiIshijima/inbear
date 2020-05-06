import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/view/screen/schedule_page.dart';
import 'package:inbear_app/view/screen/setting_page.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectIndex = 0;

  final List<Widget> _tabs = <Widget> [
    Text('Index 0: Home'),
    SchedulePage(),
    SettingPage()
  ];
  final List<String> _titleList = <String> [
    'ホーム',
    'スケジュール',
    '設定'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(_titleList.elementAt(_selectIndex),
          style: TextStyle(
            color: Colors.white
          ),),
        ),
        body: Container(
          child: _tabs.elementAt(_selectIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectIndex,
          items: const <BottomNavigationBarItem> [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('ホーム')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              title: Text('スケジュール')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('設定')
            )
          ],
          onTap: (int index) {
            setState(() {
              _selectIndex = index;
            });
          },
        ),
      ),
    );
  }

}