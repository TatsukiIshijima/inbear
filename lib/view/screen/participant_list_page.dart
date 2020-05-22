import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/repository/schedule_respository.dart';
import 'package:inbear_app/repository/user_repository.dart';
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
    return Text(
      errorMessage,
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<ParticipantListViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
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
              return Center(
                child: _errorText('${snapshot.error}'),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: _errorText('データなし'),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  controller: viewModel.scrollController,
                  itemBuilder: (context, index) => ParticipantItem(
                        userName: snapshot.data[index].name,
                        email: snapshot.data[index].email,
                        onTap: () {},
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
    return FloatingActionButton(
      onPressed: () {},
      child: const Icon(Icons.add),
    );
  }
}
