import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/schedule_respository.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/view/screen/base_page.dart';
import 'package:inbear_app/view/widget/centering_error_message.dart';
import 'package:inbear_app/view/widget/participant_item.dart';
import 'package:inbear_app/viewmodel/user_search_viewmodel.dart';
import 'package:provider/provider.dart';

class UserSearchPage extends StatelessWidget {
  final String query;

  UserSearchPage(this.query);

  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    return BasePage(
        viewModel: UserSearchViewModel(
            Provider.of<UserRepository>(context, listen: false),
            Provider.of<ScheduleRepository>(context, listen: false)),
        child: Stack(
          children: <Widget>[
            if (query.isEmpty)
              Center(
                  child: Text(
                resource.addParticipantSuggestMessage,
                textAlign: TextAlign.center,
              )),
            if (query.isNotEmpty) ParticipantYetUserList(query, resource),
            SearchResult()
          ],
        ));
  }
}

class ParticipantYetUserList extends StatelessWidget {
  final String query;
  final AppLocalizations resource;

  ParticipantYetUserList(this.query, this.resource);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserSearchViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await viewModel.executeSearchUser(query);
    });
    return StreamBuilder<List<UserEntity>>(
      initialData: null,
      stream: viewModel.searchUsersStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container();
          default:
            if (snapshot.hasError) {
              return CenteringErrorMessage(
                resource,
                exception: snapshot.error,
              );
            } else if (!snapshot.hasData) {
              return CenteringErrorMessage(
                resource,
                message: resource.notFoundEmailAddressUserMessage,
              );
            } else if (snapshot.data.isEmpty) {
              return CenteringErrorMessage(
                resource,
                message: resource.notFoundEmailAddressUserMessage,
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => ParticipantItem(
                        snapshot.data[index].name,
                        snapshot.data[index].email,
                        showAddButton: true,
                        addButtonClick: () async => await viewModel
                            .executeAddParticipant(snapshot.data[index].uid),
                      ));
            }
        }
      },
    );
  }
}

class SearchResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserSearchViewModel>(context, listen: false);
    return Selector<UserSearchViewModel, String>(
      selector: (context, viewModel) => viewModel.status,
      builder: (context, status, child) {
        switch (status) {
          case UserSearchStatus.addSuccess:
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              viewModel.searchResultClear();
            });
            break;
        }
        return Container();
      },
    );
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
        // バックボタンで戻ったときに遷移先で更新させるために引数に true を指定
        onPressed: () => close(context, true),
      );

  @override
  Widget buildResults(BuildContext context) {
    return UserSearchPage(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context).addParticipantSuggestMessage,
        textAlign: TextAlign.center,
      ),
    );
  }
}
