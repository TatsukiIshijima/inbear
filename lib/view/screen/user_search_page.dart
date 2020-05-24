import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/repository/schedule_respository.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/view/widget/loading.dart';
import 'package:inbear_app/view/widget/participant_item.dart';
import 'package:inbear_app/viewmodel/participant_edit_viewmodel.dart';
import 'package:provider/provider.dart';

class UserSearchPage extends StatelessWidget {
  final String query;

  UserSearchPage(this.query);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ParticipantEditViewModel(
            Provider.of<UserRepository>(context, listen: false),
            Provider.of<ScheduleRepository>(context, listen: false)),
        child: Stack(
          children: <Widget>[
            if (query.isEmpty) Center(child: Text('メールアドレスからユーザーを検索しましょう。')),
            if (query.isNotEmpty) ParticipantYetUserList(query)
          ],
        ));
  }
}

class ParticipantYetUserList extends StatelessWidget {
  final String query;

  ParticipantYetUserList(this.query);

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<ParticipantEditViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await viewModel.searchUser(query);
    });
    return StreamBuilder<List<UserEntity>>(
      initialData: null,
      stream: viewModel.searchUsersStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: Loading(),
            );
          default:
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text('ユーザーが見つかりません。\n（既に参加されている方や自分自身は表示されません。）'),
              );
            } else if (snapshot.data.isEmpty) {
              return Center(
                child: Text('ユーザーが見つかりません。\n（既に参加されている方や自分自身は表示されません。）'),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => ParticipantItem(
                        userName: snapshot.data[index].name,
                        email: snapshot.data[index].email,
                        showAddButton: true,
                        addButtonClick: () {},
                      ));
            }
        }
      },
    );
  }
}

class OverlapLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

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
    return UserSearchPage(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('メールアドレスからユーザーを検索しましょう。'),
    );
  }
}
