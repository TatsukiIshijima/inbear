import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/view/screen/user_search_delegate.dart';

class ParticipantEditPage extends StatelessWidget {
  // バックボタン等でこの画面に戻ってきたときに実行する処理
  Future<void> _returnEvent() async {
    debugPrint('BackFromUserSearch');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('参加者編集'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              '追加',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              final route = await showSearch<bool>(
                  context: context,
                  delegate: UserSearchDelegate(
                      searchFieldLabel: 'メールアドレス',
                      keyboardType: TextInputType.emailAddress));
              if (route != null) {
                await _returnEvent();
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Text('一覧表示'),
      ),
    );
  }
}
