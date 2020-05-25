import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/schedule_respository.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/view/widget/centering_error_message.dart';
import 'package:inbear_app/view/widget/loading.dart';
import 'package:inbear_app/view/widget/participant_item.dart';
import 'package:inbear_app/view/widget/single_button_dialog.dart';
import 'package:inbear_app/viewmodel/user_search_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../status.dart';

class UserSearchPage extends StatelessWidget {
  final String query;

  UserSearchPage(this.query);

  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    return ChangeNotifierProvider(
        create: (context) => UserSearchViewModel(
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
            OverlapLoading(resource)
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
                        userName: snapshot.data[index].name,
                        email: snapshot.data[index].email,
                        showAddButton: true,
                        addButtonClick: () async => await viewModel
                            .addParticipant(snapshot.data[index].uid),
                      ));
            }
        }
      },
    );
  }
}

class OverlapLoading extends StatelessWidget {
  final AppLocalizations resource;

  OverlapLoading(this.resource);

  void _showErrorDialog(BuildContext context, String title, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog<SingleButtonDialog>(
          context: context,
          builder: (context) => SingleButtonDialog(
                title: title,
                message: message,
                positiveButtonTitle: resource.defaultPositiveButtonTitle,
                onPressed: () => Navigator.pop(context),
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<UserSearchViewModel, String>(
      selector: (context, viewModel) => viewModel.status,
      builder: (context, status, child) {
        switch (status) {
          case Status.loading:
            return Container(
              decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.3)),
              child: Center(
                child: Loading(),
              ),
            );
          case Status.success:
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.pop(context, true);
            });
            break;
          case Status.unLoginError:
            _showErrorDialog(context, resource.addParticipantErrorTitle,
                resource.unloginError);
            break;
          case UserSearchStatus.userDataNotExistError:
            _showErrorDialog(context, resource.addParticipantErrorTitle,
                resource.notExistUserDataError);
            break;
          case Status.timeoutError:
            _showErrorDialog(context, resource.addParticipantErrorTitle,
                resource.timeoutError);
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
        onPressed: () => close(context, false),
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
