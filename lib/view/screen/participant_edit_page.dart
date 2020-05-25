import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/model/participant_item_model.dart';
import 'package:inbear_app/repository/schedule_respository.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/view/screen/user_search_page.dart';
import 'package:inbear_app/view/widget/centering_error_message.dart';
import 'package:inbear_app/view/widget/loading.dart';
import 'package:inbear_app/view/widget/participant_item.dart';
import 'package:inbear_app/viewmodel/participant_edit_viewmodel.dart';
import 'package:provider/provider.dart';

class ParticipantEditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ParticipantEditViewModel(
          Provider.of<UserRepository>(context, listen: false),
          Provider.of<ScheduleRepository>(context, listen: false)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('参加者編集'),
          actions: <Widget>[
            AddParticipantButton(),
          ],
        ),
        body: ParticipantEditList(),
      ),
    );
  }
}

class AddParticipantButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<ParticipantEditViewModel>(context, listen: false);
    return FlatButton(
      child: Text(
        '追加',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () async {
        final updateFlag = await showSearch<bool>(
            context: context,
            delegate: UserSearchDelegate(
                searchFieldLabel: 'メールアドレス',
                keyboardType: TextInputType.emailAddress));
        // Navigator.pop で result に bool を入れて前の画面に戻したときに
        // result に値が入っているので、それで前の画面から戻ってきているか検知
        if (updateFlag != null && updateFlag) {
          debugPrint('BackFromUserSearch');
          await viewModel.fetchParticipantsStart();
        }
      },
    );
  }
}

class ParticipantEditList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    final viewModel =
        Provider.of<ParticipantEditViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      viewModel.setScrollListener();
      await viewModel.fetchParticipantsStart();
    });
    return StreamBuilder<List<ParticipantItemModel>>(
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
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  controller: viewModel.scrollController,
                  itemBuilder: (context, index) => ParticipantItem(
                        userName: snapshot.data[index].name,
                        email: snapshot.data[index].email,
                        showDeleteButton: !snapshot.data[index].isOwner,
                        deleteButtonClick: () {},
                      ));
            }
        }
      },
    );
  }
}
