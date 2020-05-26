import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/schedule_respository.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/routes.dart';
import 'package:inbear_app/view/widget/centering_error_message.dart';
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
        floatingActionButton: EditParticipantButton(),
      ),
    );
  }
}

class ParticipantList extends StatelessWidget {
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
              return CenteringErrorMessage(
                resource,
                exception: snapshot.error,
              );
            } else if (!snapshot.hasData) {
              return CenteringErrorMessage(resource,
                  message: resource.participantsEmptyErrorMessage);
            } else if (snapshot.data.isEmpty) {
              return CenteringErrorMessage(resource,
                  message: resource.participantsEmptyErrorMessage);
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

class EditParticipantButton extends StatelessWidget {
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
            onPressed: () => Routes.goToParticipantEdit(context),
            child: const Icon(Icons.edit),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
