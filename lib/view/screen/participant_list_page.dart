import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/view/widget/participant_item.dart';

class ParticipantListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParticipantListContent(),
      floatingActionButton: AddParticipantButton(),
    );
  }
}

class ParticipantListContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ParticipantList();
  }
}

class ParticipantList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => ParticipantItem(
              userName: 'サンプル',
              email: 'sample@example.com',
              onTap: () {},
            ));
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
