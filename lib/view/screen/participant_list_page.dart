import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/model/participant_item_model.dart';
import 'package:inbear_app/repository/schedule_respository.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/status.dart';
import 'package:inbear_app/view/screen/base_page.dart';
import 'package:inbear_app/view/screen/user_search_page.dart';
import 'package:inbear_app/view/widget/centering_error_message.dart';
import 'package:inbear_app/view/widget/default_dialog.dart';
import 'package:inbear_app/view/widget/participant_item.dart';
import 'package:inbear_app/view/widget/reload_button.dart';
import 'package:inbear_app/viewmodel/participant_list_viewmodel.dart';
import 'package:provider/provider.dart';

class ParticipantListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ParticipantListPageState();
}

class ParticipantListPageState extends State<ParticipantListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BasePage<ParticipantListViewModel>(
      viewModel: ParticipantListViewModel(
          Provider.of<UserRepository>(context, listen: false),
          Provider.of<ScheduleRepository>(context, listen: false)),
      child: Scaffold(
        body: ParticipantListPageBody(),
        floatingActionButton: AddParticipantButton(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ParticipantListPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<ParticipantListViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await viewModel.executeFetchParticipantsStart();
      await viewModel.checkScheduleOwner();
    });
    return Stack(
      children: <Widget>[ParticipantList(), DeleteResult()],
    );
  }
}

class ParticipantList extends StatelessWidget {
  void _showConfirmDialog(
      BuildContext context, Future<void> Function() deleteFunc) {
    final resource = AppLocalizations.of(context);
    showDialog<DefaultDialog>(
        context: context,
        builder: (context) => DefaultDialog(
              resource.deleteParticipantTitle,
              resource.deleteParticipantMessage,
              positiveButtonTitle: resource.defaultPositiveButtonTitle,
              negativeButtonTitle: resource.defaultNegativeButtonTitle,
              onPositiveButtonPressed: () async => await deleteFunc(),
              onNegativeButtonPressed: () {},
            ));
  }

  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    final viewModel =
        Provider.of<ParticipantListViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      viewModel.setScrollListener();
    });
    return StreamBuilder<List<ParticipantItemModel>>(
      initialData: null,
      stream: viewModel.participantsStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container();
          default:
            if (snapshot.hasError) {
              if (snapshot.error is TimeoutException) {
                return ReloadButton(
                  onPressed: () async =>
                      await viewModel.executeFetchParticipantsStart(),
                );
              } else {
                return CenteringErrorMessage(
                  resource,
                  exception: snapshot.error,
                );
              }
            } else if (!snapshot.hasData) {
              return CenteringErrorMessage(resource,
                  message: resource.participantsEmptyErrorMessage);
            } else if (snapshot.data.isEmpty) {
              return CenteringErrorMessage(resource,
                  message: resource.participantsEmptyErrorMessage);
            } else {
              return Selector<ParticipantListViewModel, bool>(
                selector: (context, viewModel) => viewModel.isOwnerSchedule,
                builder: (context, isOwnerSchedule, child) => ListView.builder(
                    itemCount: snapshot.data.length,
                    controller: viewModel.scrollController,
                    itemBuilder: (context, index) {
                      if (isOwnerSchedule) {
                        // オーナーであれば、ユーザーの削除可能
                        // ただし、自分自身は削除できないようにする
                        return ParticipantItem(
                          snapshot.data[index].name,
                          snapshot.data[index].email,
                          showDeleteButton: !snapshot.data[index].isOwner,
                          deleteButtonClick: () =>
                              _showConfirmDialog(context, () async {
                            await viewModel.executeDeleteParticipant(
                                snapshot.data[index].uid);
                          }),
                        );
                      } else {
                        return ParticipantItem(snapshot.data[index].name,
                            snapshot.data[index].email);
                      }
                    }),
              );
            }
        }
      },
    );
  }
}

class DeleteResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<ParticipantListViewModel>(context, listen: false);
    return Selector<ParticipantListViewModel, Status>(
      selector: (context, viewModel) => viewModel.status,
      builder: (context, status, child) {
        switch (status) {
          case ParticipantListStatus.deleteParticipantSuccess:
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) async =>
                await viewModel.executeFetchParticipantsStart());
            break;
        }
        return Container();
      },
    );
  }
}

class AddParticipantButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<ParticipantListViewModel>(context, listen: false);
    return Selector<ParticipantListViewModel, bool>(
      selector: (context, viewModel) => viewModel.isOwnerSchedule,
      builder: (context, isOwnerSchedule, child) {
        if (isOwnerSchedule) {
          return FloatingActionButton(
            heroTag: 'AddParticipant',
            onPressed: () async {
              final updateFlag = await showSearch<bool>(
                  context: context,
                  delegate: UserSearchDelegate(
                      searchFieldLabel: 'メールアドレス',
                      keyboardType: TextInputType.emailAddress));
              // Navigator.pop で result に bool を入れて前の画面に戻したときに
              // result に値が入っているので、それで前の画面から戻ってきているか検知
              if (updateFlag != null && updateFlag) {
                await viewModel.executeFetchParticipantsStart();
              }
            },
            child: const Icon(Icons.person_add),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
