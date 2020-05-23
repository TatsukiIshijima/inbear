import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/schedule_respository.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/view/screen/user_search_delegate.dart';
import 'package:inbear_app/view/widget/loading.dart';
import 'package:inbear_app/view/widget/participant_item.dart';
import 'package:inbear_app/viewmodel/participant_list_viewmodel.dart';
import 'package:provider/provider.dart';

class ParticipantListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ParticipantListViewModel(
          Provider.of<UserRepository>(context, listen: false),
          Provider.of<ScheduleRepository>(context, listen: false)),
      child: Scaffold(
        body: ParticipantList(),
        floatingActionButton: AddParticipantButton(),
      ),
    );
  }
}

class ParticipantList extends StatelessWidget {
  Widget _errorText(String errorMessage) {
    return Center(
        child: Text(
      errorMessage,
      textAlign: TextAlign.center,
    ));
  }

  Widget _showErrorMessage(Object snapshotError, AppLocalizations resource) {
    if (snapshotError is UnLoginException) {
      return _errorText(resource.unloginError);
    } else if (snapshotError is UserDocumentNotExistException) {
      return _errorText(resource.notExistUserDataError);
    } else if (snapshotError is NoSelectScheduleException) {
      return _errorText(resource.noSelectScheduleError);
    } else if (snapshotError is ParticipantsEmptyException) {
      return _errorText(resource.participantsEmptyErrorMessage);
    } else if (snapshotError is TimeoutException) {
      return _errorText(resource.timeoutError);
    } else {
      return _errorText(resource.generalError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    final viewModel =
        Provider.of<ParticipantListViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      viewModel.setScrollListener();
      await viewModel.fetchParticipantsStart();
    });
    return StreamBuilder<List<UserEntity>>(
      initialData: null,
      stream: viewModel.participantsStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: Loading());
          default:
            if (snapshot.hasError) {
              return _showErrorMessage(snapshot.error, resource);
            } else if (!snapshot.hasData) {
              return Center(
                child: _errorText(resource.participantsEmptyErrorMessage),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  controller: viewModel.scrollController,
                  itemBuilder: (context, index) => ParticipantItem(
                        userName: snapshot.data[index].name,
                        email: snapshot.data[index].email,
                      ));
            }
        }
      },
    );
  }
}

class AddParticipantButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<ParticipantListViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await viewModel.checkScheduleOwner();
    });
    return Selector<ParticipantListViewModel, bool>(
      selector: (context, viewModel) => viewModel.isOwnerSchedule,
      builder: (context, isOwnerSchedule, child) {
        if (isOwnerSchedule) {
          return FloatingActionButton(
            onPressed: () => showSearch(
                context: context,
                delegate: UserSearchDelegate(
                    searchFieldLabel: 'メールアドレス',
                    keyboardType: TextInputType.emailAddress)),
            child: const Icon(Icons.add),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
