import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/repository/schedule_respository.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/view/screen/user_search_delegate.dart';
import 'package:inbear_app/viewmodel/participant_edit_viewmodel.dart';
import 'package:provider/provider.dart';

class ParticipantEditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ParticipantEditViewModel(
        Provider.of<UserRepository>(context, listen: false),
        Provider.of<ScheduleRepository>(context, listen: false)
      ),
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
        final route = await showSearch<bool>(
            context: context,
            delegate: UserSearchDelegate(viewModel,
                searchFieldLabel: 'メールアドレス',
                keyboardType: TextInputType.emailAddress));
        // Navigator.pop で result に bool を入れて前の画面に戻したときに
        // result に値が入っているので、それで前の画面から戻ってきているか検知
        if (route != null) {
          debugPrint('BackFromUserSearch');
          await viewModel.fetchParticipants();
        }
      },
    );
  }
}

class ParticipantEditList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<ParticipantEditViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await viewModel.fetchParticipants();
    });
    return Center(
      child: Text('一覧表示'),
    );
  }
}
