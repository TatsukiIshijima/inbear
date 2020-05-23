import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserSearchDelegate extends SearchDelegate<bool> {
  @override
  final String searchFieldLabel;
  @override
  final TextInputType keyboardType;

  UserSearchDelegate({this.searchFieldLabel, this.keyboardType});

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => query = '',
        )
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        // Themeからうまく引き継いだ色にならなかったので指定
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => close(context, true),
      );

  @override
  Widget buildResults(BuildContext context) {
    // TODO:ここに検索実行時のレイアウト追加
    if (query.isEmpty) {
      return Center(
        child: Text('メールアドレスからユーザーを検索しましょう。'),
      );
    } else {
      return Center(
        child: Text('ここに検索結果を表示'),
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }
}
