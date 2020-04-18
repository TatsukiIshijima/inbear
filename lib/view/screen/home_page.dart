import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/strings.dart';
import 'package:inbear_app/view/screen/setting_page.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectIndex = 0;

  final List<Widget> _tabs = <Widget> [
    Text('Index 0: Home'),
    Text('Index 1: Schedule'),
    SettingPage()
  ];
  final List<String> _titleList = <String> [
    Strings.HomeTitle,
    Strings.ScheduleTitle,
    Strings.SettingsTitle
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              title: Text(Strings.HomeTitle)
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              title: Text(Strings.ScheduleTitle)
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text(Strings.SettingsTitle)
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